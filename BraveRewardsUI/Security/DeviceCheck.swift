// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import DeviceCheck

/// A structure used to register a device for Brave's DeviceCheck enrollment
public struct DeviceCheckRegistration: Codable {
  // The enrollment blob is a Base64 Encoded `DeviceCheckEnrollment` structure
  let enrollmentBlob: DeviceCheckEnrollment
  
  /// The signature is base64(token) + the base64(publicKey) signed using the privateKey.
  let signature: String
  
  public init(enrollmentBlob: DeviceCheckEnrollment, signature: String) {
    self.enrollmentBlob = enrollmentBlob
    self.signature = signature
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    guard let data = Data(base64Encoded: try container.decode(String.self, forKey: .enrollmentBlob)) else {
      throw NSError(domain: "com.brave.device.check.enrollment", code: -1, userInfo: [
        NSLocalizedDescriptionKey: "Cannot decode enrollmentBlob"
      ])
    }
    
    enrollmentBlob = try JSONDecoder().decode(DeviceCheckEnrollment.self, from: data)
    signature = try container.decode(String.self, forKey: .signature)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let data = try JSONEncoder().encode(enrollmentBlob).base64EncodedString()
    try container.encode(data, forKey: .enrollmentBlob)
    try container.encode(signature, forKey: .signature)
  }
  
  enum CodingKeys: String, CodingKey {
    case enrollmentBlob
    case signature
  }
}

public struct DeviceCheckEnrollment: Codable {
  // Not sure yet
  let paymentID: String
  
  // The public key in ASN.1 DER format (PEM).
  // Until the server is working, we will never be sure if the key should be with the universal key octets included.
  // TODO: Wait on test server..
  let publicKey: String
  
  // The device check token base64 encoded.
  let deviceToken: String
}

/// A structure used to respond to a nonce challenge
public struct AttestationVerifcation: Codable {
  // The attestation blob is a base-64 encoded version of `AttestationBlob`
  let attestationBlob: AttestationBlob
  
  // The signature is the `nonce` signed by the privateKey and base-64 encoded.
  let signature: String
  
  public init(attestationBlob: AttestationBlob, signature: String) {
    self.attestationBlob = attestationBlob
    self.signature = signature
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    guard let data = Data(base64Encoded: try container.decode(String.self, forKey: .attestationBlob)) else {
      throw NSError(domain: "com.brave.device.check.enrollment", code: -1, userInfo: [
        NSLocalizedDescriptionKey: "Cannot decode attestationBlob"
      ])
    }
    
    attestationBlob = try JSONDecoder().decode(AttestationBlob.self, from: data)
    signature = try container.decode(String.self, forKey: .signature)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let data = try JSONEncoder().encode(attestationBlob).base64EncodedString()
    try container.encode(data, forKey: .attestationBlob)
    try container.encode(signature, forKey: .signature)
  }
  
  enum CodingKeys: String, CodingKey {
    case attestationBlob
    case signature
  }
}

public struct AttestationBlob: Codable {
  // The nonce is a UUIDv4 string
  let nonce: String
}

class DeviceCheckFlow {
  
  // The ID of the private-key stored in the secure-enclave chip
  private static let privateKeyId = "com.brave.device.check.private.key"
  
  // Registers a device with the server using the device-check token
  public func registerDevice(enrollment: DeviceCheckRegistration, _ completion: @escaping (Error?) -> Void) {
    do {
      var request = URLRequest(url: URL(string: "/v1/devicecheck/enrollments")!)
      request.httpMethod = "POST"
      request.httpBody = try JSONEncoder().encode(enrollment)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      URLSession(configuration: .ephemeral).dataTask(with: request) { data, response, error in
        
        if let error = error {
          return completion(error)
        }
        
        // Not sure what this call returns yet..
        completion(nil)
      }.resume()
    } catch {
      completion(error)
    }
  }
  
  // Retrieves existing attestations for this device and returns a nonce if any
  public func getAttestation(paymentId: String, _ completion: @escaping (AttestationBlob?, Error?) -> Void) {
    do {
      guard let privateKey = try Cryptography.getExistingKey(id: DeviceCheckFlow.privateKeyId) else {
        throw CryptographyError(code: -1, description: "Unable to retrieve existing private key")
      }
      
      //Honestly not sure why this is in the query parameters..
      //Documentation doesn't specify what format the key should be in the query parameters.. so we send ASN.1 DER (PEM) encoding and URL encode it
      guard let publicKeyData = try privateKey.getPublicKeyExternalRepresentation(), let publicKey = String(data: publicKeyData, encoding: .utf8) else {
        throw CryptographyError(code: -1, description: "Unable to retrieve public key")
      }
      
      let parameters = [
        "publicKey": publicKey,
        "paymentId": paymentId
      ]
      
      var request = URLRequest(url: URL(string: "/v1/devicecheck/attestations")!)
      var urlComponents = URLComponents()
      urlComponents.scheme = request.url?.scheme
      urlComponents.host = request.url?.host
      urlComponents.path = request.url?.path ?? ""
      urlComponents.queryItems = parameters.map({
        URLQueryItem(name: $0.key, value: $0.value)
      })
      
      request.url = urlComponents.url
      request.httpMethod = "GET"
      request.httpBody = nil
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      
      URLSession(configuration: .ephemeral).dataTask(with: request) { data, response, error in
        if let error = error {
          return completion(nil, error)
        }
        
        if let response = response as? HTTPURLResponse {
          if response.statusCode < 200 || response.statusCode > 299 {
            completion(nil, error) //Validation failed..
          }
        }
        
        guard let data = data else {
          return completion(nil, error) //No response from the server..
        }
        
        do {
          let blob = try JSONDecoder().decode(AttestationBlob.self, from: data)
          completion(blob, nil)
        } catch {
          completion(nil, error)
        }
      }.resume()
    } catch {
      completion(nil, error)
    }
  }
  
  // Sends the attestation to the server along with the nonce and the challenge signature
  public func setAttestation(nonce: String, _ completion: @escaping (Error?) -> Void) {
    do {
      guard let privateKey = try Cryptography.getExistingKey(id: DeviceCheckFlow.privateKeyId) else {
        throw CryptographyError(code: -1, description: "Unable to retrieve existing private key")
      }
      
      let signature = try privateKey.sign(message: nonce).base64EncodedString()
      
      let attestationBlob = AttestationBlob(nonce: nonce)
      let verification = AttestationVerifcation(attestationBlob: attestationBlob,
                                                signature: signature)
      
      let parameters = [
        "nonce": nonce
      ]
      
      var request = URLRequest(url: URL(string: "/v1/devicecheck/attestations")!)
      var urlComponents = URLComponents()
      urlComponents.scheme = request.url?.scheme
      urlComponents.host = request.url?.host
      urlComponents.path = request.url?.path ?? ""
      urlComponents.queryItems = parameters.map({
        URLQueryItem(name: $0.key, value: $0.value)
      })
      
      request.url = urlComponents.url
      request.httpMethod = "PUT"
      request.httpBody = try JSONEncoder().encode(verification)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      
      URLSession(configuration: .ephemeral).dataTask(with: request) { data, response, error in
        if let error = error {
          return completion(error)
        }
        
        //No idea what the server is supposed to return..
      }.resume()
    } catch {
      completion(error)
    }
  }
  
  // Generates a device-check token
  public func generateToken(_ completion: @escaping (String, Error?) -> Void) {
        DCDevice.current.generateToken { data, error in
          if let error = error {
            return completion("", error)
          }
          
          guard let deviceCheckToken = data?.base64EncodedString() else {
            return completion("", error)
          }
          
          completion(deviceCheckToken, nil)
    }
  }
  
  // generates an enrollment structure to be used with `registerDevice`
  public func generateEnrollment(paymentId: String, token: String, _ completion: (DeviceCheckRegistration?, Error?) -> Void) {
    do {
      guard let privateKey = try Cryptography.generateKey(id: DeviceCheckFlow.privateKeyId) else {
        throw CryptographyError(code: -1, description: "Unable to generate private key")
      }
      
      guard let publicKeyData = try privateKey.getPublicKeyExternalRepresentation(), let publicKey = String(data: publicKeyData, encoding: .utf8) else {
        throw CryptographyError(code: -1, description: "Unable to retrieve public key")
      }
      
      let signature = try privateKey.sign(message: publicKey + token).base64EncodedString()
      
      let enrollmentBlob = DeviceCheckEnrollment(paymentID: paymentId,
                                                       publicKey: publicKey,
                                                       deviceToken: token)
      let registration = DeviceCheckRegistration(enrollmentBlob: enrollmentBlob,
                                                       signature: signature)
      completion(registration, nil)
    } catch {
      completion(nil, error)
    }
  }
}
