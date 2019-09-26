// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import DeviceCheck

public struct DeviceCheckRegistration: Codable {
  let enrollmentBlob: DeviceCheckEnrollment
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
  let paymentID: String
  let publicKey: String
  let deviceToken: String
}

public struct AttestationVerifcation: Codable {
  let attestationBlob: AttestationBlob
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
  let nonce: String
}

/// An error class representing an error that has occurred when handling encryption
public struct CryptographyError: Error {
  //The error domain
  public let domain: String
  
  //The error code
  public let code: Int32
  
  //A description of the error
  public let description: String?
  
  init(code: Int32, description: String? = nil) {
    self.domain = "com.brave.security.cryptography.error"
    self.code = code
    self.description = description
  }
}

/// A class representing a cryptographic key.
public struct CryptographicKey {
  private let key: SecKey
  private let keyId: String
  
  public init(key: SecKey, keyId: String) {
    self.key = key
    self.keyId = keyId
  }
  
  /// Returns the private key
  public func getPrivateKey() -> SecKey {
    return key
  }
  
  /// Returns the public key
  public func getPublicKey() -> SecKey? {
    return SecKeyCopyPublicKey(key)
  }
  
  /// Returns the public key in ASN.1 format
  public func getPublicKeyExternalRepresentation() throws -> Data? {
    guard let publicKey = getPublicKey() else {
      throw CryptographyError(code: -1, description: "Cannot retrieve public key")
    }
    
    var error: Unmanaged<CFError>?
    if let data = SecKeyCopyExternalRepresentation(publicKey, &error) {
      return data as Data
    }
    
    if let error = error?.takeUnretainedValue() {
      throw error
    }
    
    return nil
  }
  
  /// Deletes the key from the secure-enclave and keychain
  @discardableResult
  public func delete() -> Error? {
    let error = SecItemDelete([
      kSecClass: kSecClassKey,
      kSecAttrApplicationTag: keyId.data(using: .utf8)!
    ] as CFDictionary)
    
    if error == errSecSuccess || error == errSecItemNotFound {
      return nil
    }
    
    return CryptographyError(code: error)
  }
  
  /// Signs a "message" with the key and returns the signature
  public func sign(message: String) throws -> Data {
    var error: Unmanaged<CFError>?
    let signature = SecKeyCreateSignature(key,
                                          .ecdsaSignatureMessageX962SHA256,
                                          message.data(using: .utf8)! as CFData,
                                          &error)
    
    if let error = error?.takeUnretainedValue() {
      throw error as Error
    }
    
    guard let result = signature as Data? else {
      throw CryptographyError(code: -1, description: "Cannot sign message with cryptographic key.")
    }
    
    return result
  }
}

/// A class used for generating cryptographic keys
public class Cryptography {
  
  /// The access control flags for any keys generated
  public static let accessControlFlags = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, [.privateKeyUsage, .biometryAny], nil)
  
  /// Retrieves an existing key from the secure-enclave
  public class func getExistingKey(id: String) throws -> CryptographicKey? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassKey,
      kSecAttrApplicationTag: id.data(using: .utf8)!,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnRef: kCFBooleanTrue as Any
    ]
    
    var result: CFTypeRef?
    let error = SecItemCopyMatching(query as CFDictionary, &result)
    if error == errSecSuccess || error == errSecDuplicateItem || error == errSecInteractionNotAllowed {
      if let res = result {
        return CryptographicKey(key: res as! SecKey, keyId: id) //swiftlint:disable:this force_cast
      }
      return nil
    }
    
    if error == errSecItemNotFound {
      return nil
    }
    
    throw CryptographyError(code: error)
  }
  
  /// Generates a new key and stores it in the secure-enclave
  /// If a key with the specified ID already exists, it retrieves the existing key instead
  public class func generateKey(id: String,
                                bits: UInt16 = 256,
                                storeInKeychain: Bool = true,
                                secureEnclave: Bool = true,
                                controlFlags: SecAccessControl? = Cryptography.accessControlFlags) throws -> CryptographicKey? {
    
    if let key = try getExistingKey(id: id) {
      return key
    }
    
    let attributes: [CFString: Any] = [
      kSecClass: kSecClassKey,
      kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrKeySizeInBits: bits,
      kSecAttrCreator: "com.brave.security.cryptography",
      kSecAttrTokenID: (secureEnclave ? kSecAttrTokenIDSecureEnclave : nil) as Any,
      kSecPrivateKeyAttrs: [
        kSecAttrIsPermanent: storeInKeychain,
        kSecAttrApplicationTag: id.data(using: .utf8)!,
        kSecAttrAccessControl: (controlFlags ?? nil) as Any
      ]
    ]
    
    var error: Unmanaged<CFError>?
    let key = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
    
    if let error = error?.takeUnretainedValue() {
      throw error as Error
    }
    
    guard let pKey = key else {
      throw CryptographyError(code: -1, description: "Cannot generate cryptographic key.")
    }
    
    return CryptographicKey(key: pKey, keyId: id)
  }
}

class DeviceCheckFlow {
  
  private static let privateKeyId = "com.brave.device.check.private.key"
  
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
  
  public func getAttestation(paymentId: String, _ completion: @escaping (AttestationBlob?, Error?) -> Void) {
    do {
      guard let privateKey = try Cryptography.getExistingKey(id: DeviceCheckFlow.privateKeyId) else {
        throw CryptographyError(code: -1, description: "Unable to retrieve existing private key")
      }
      
      //Honestly not sure why this is in the query parameters..
      guard let publicKeyData = try privateKey.getPublicKeyExternalRepresentation()?.base64EncodedString() else {
        throw CryptographyError(code: -1, description: "Unable to retrieve public key")
      }
      
      let parameters = [
        "publicKey": publicKeyData,
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
  
  public func generateEnrollment(paymentId: String, token: String, _ completion: (DeviceCheckRegistration?, Error?) -> Void) {
    do {
      guard let privateKey = try Cryptography.generateKey(id: DeviceCheckFlow.privateKeyId) else {
        throw CryptographyError(code: -1, description: "Unable to generate private key")
      }
      
      guard let publicKeyData = try privateKey.getPublicKeyExternalRepresentation()?.base64EncodedString() else {
        throw CryptographyError(code: -1, description: "Unable to retrieve public key")
      }
      
      let signature = try privateKey.sign(message: publicKeyData + token).base64EncodedString()
      
      let enrollmentBlob = DeviceCheckEnrollment(paymentID: paymentId,
                                                       publicKey: publicKeyData,
                                                       deviceToken: token)
      let registration = DeviceCheckRegistration(enrollmentBlob: enrollmentBlob,
                                                       signature: signature)
      completion(registration, nil)
    } catch {
      completion(nil, error)
    }
  }
}
