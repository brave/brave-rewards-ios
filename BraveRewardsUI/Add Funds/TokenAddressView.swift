/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import CoreImage

public class TokenAddressView: UIView {
  
  @objc public enum TokenKind: Int {
    case bitcoin
    case ethereum
    case basicAttentionToken
    case litecoin
    
    var name: String {
      switch self {
      case .bitcoin:
        return "Bitcoin (BTC)"
      case .ethereum:
        return "Ethereum (ETH)"
      case .basicAttentionToken:
        return "Basic Attention Token (BAT)"
      case .litecoin:
        return "Litecoin (LTC)"
      }
    }
    var image: UIImage {
      return UIImage(frameworkResourceNamed: "bat-dragable")
    }
  }
  
  @objc public func setQRCode(image: UIImage?) {
    qrCodeView.qrCodeButton.isHidden = image != nil
    qrCodeView.imageView.image = image
  }
  
  @objc public var viewQRCodeButtonTapped: ((TokenAddressView) -> Void)?
  
  @objc public let addressTextView = UITextView().then {
    $0.isScrollEnabled = false
    $0.isEditable = false
    $0.layer.borderColor = Colors.grey600.cgColor
    $0.layer.borderWidth = 1.0 / UIScreen.main.scale
    $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    $0.layer.cornerRadius = 4.0
    $0.textColor = Colors.grey100
    $0.font = UIFont(name: "Menlo-Regular", size: 13.0)
  }
  
  @objc public let tokenKind: TokenKind
  
  private let qrCodeView = QRCodeView()
  
  @objc public init(tokenKind: TokenKind) {
    self.tokenKind = tokenKind
    
    super.init(frame: .zero)
    
    let containerStackView = UIStackView().then {
      $0.axis = .vertical
      $0.spacing = 10.0
    }
    
    qrCodeView.qrCodeButton.addTarget(self, action: #selector(tappedQRCodeButton), for: .touchUpInside)
    
    addSubview(containerStackView)
    containerStackView.addStackViewItems(
      .view(UIStackView().then {
        $0.spacing = 20.0
        $0.alignment = .center
        $0.addStackViewItems(
          .view(UIImageView(image: tokenKind.image).then {
            $0.contentMode = .scaleAspectFit
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.snp.makeConstraints {
              $0.width.height.equalTo(38.0)
            }
          }),
          .view(UILabel().then {
            $0.text = tokenKind.name
            $0.font = .systemFont(ofSize: 14.0)
            $0.numberOfLines = 0
          })
        )
      }),
      .customSpace(15.0),
      .view(UILabel().then {
        $0.text = BATLocalizedString("BraveRewardsAddFundsTokenWalletAddress", "Wallet Address")
        $0.font = .systemFont(ofSize: 12.0, weight: .medium)
        $0.textColor = Colors.grey100
      }),
      .customSpace(4.0),
      .view(addressTextView),
      .view(qrCodeView)
    )
    
    containerStackView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  @objc private func tappedQRCodeButton() {
    viewQRCodeButtonTapped?(self)
  }
}

extension TokenAddressView {
  final class QRCodeView: UIView {
    let imageView = UIImageView().then {
      $0.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
      $0.contentMode = .scaleAspectFit
      $0.layer.magnificationFilter = .nearest
    }
    let qrCodeButton = ActionButton(type: .system).then {
      $0.setTitle(BATLocalizedString("BraveRewardsAddFundsShowQRCode", "Show QR Code"), for: .normal)
      $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
      $0.backgroundColor = Colors.blurple400
      $0.layer.borderWidth = 0
    }
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(imageView)
      addSubview(qrCodeButton)
      
      imageView.snp.makeConstraints {
        $0.centerX.equalTo(self)
        $0.width.height.equalTo(90)
        $0.top.bottom.equalTo(self)
      }
      qrCodeButton.snp.makeConstraints {
        $0.center.equalTo(self)
        $0.height.equalTo(38.0)
      }
    }
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}

extension TokenAddressView {
  @objc(BATQRCode) public final class QRCode: NSObject {
    @objc public static func image(for code: String, size: CGSize) -> UIImage? {
      guard let filter = CIFilter(name: "CIQRCodeGenerator"),
        let data = code.data(using: .utf8) else {
        return nil
      }
      filter.setValue(data, forKey: "inputMessage")
      guard let ciImage = filter.outputImage else {
        return nil
      }
      let genSize = ciImage.extent.integral.size
      let scale = UIScreen.main.scale
      let scaledSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
      let resizedImage = ciImage.transformed(by: CGAffineTransform(
        scaleX: scaledSize.width / genSize.width,
        y: scaledSize.height / genSize.height
      ))
      return UIImage(
        ciImage: resizedImage,
        scale: scale,
        orientation: .up
      )
    }
  }
}
