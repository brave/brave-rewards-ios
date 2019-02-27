/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class PublisherView: UIStackView {
  
  @objc(setVerificationStatusHidden:)
  public func setVerificationStatusHidden(_ hidden: Bool) {
    verifiedLabelStackView.isHidden = hidden
  }
  
  @objc(setVerifiedStatus:)
  public func setVerified(_ status: Bool) {
    if status {
      verificationSymbolImageView.image = UIImage(frameworkResourceNamed: "icn-verify")
      verifiedLabel.text = BATLocalizedString("BraveRewardsVerified", "Brave Verified Publisher")
      unverifiedDisclaimerView.isHidden = true
    } else {
      verificationSymbolImageView.image = UIImage(frameworkResourceNamed: "icn-unverified")
      verifiedLabel.text = BATLocalizedString("BraveRewardsNotYetVerified", "Not yet verified")
      unverifiedDisclaimerView.isHidden = false
    }
  }
  
  @objc public let faviconImageView = UIImageView().then {
    $0.backgroundColor = UX.faviconBackgroundColor
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = UX.faviconSize.width / 2.0
    $0.layer.borderColor = UX.faviconBorderColor.cgColor
    $0.layer.borderWidth = 1.0 / UIScreen.main.scale
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  // "reddit.com" / "Bart Baker on YouTube"
  @objc public let publisherNameLabel = UILabel().then {
    $0.textColor = UX.publisherNameColor
    $0.font = .systemFont(ofSize: 18.0, weight: .medium)
    $0.numberOfLines = 0
  }
  
  /// The learn more button on the unverified publisher disclaimer was tapped
  @objc public var learnMoreTapped: (() -> Void)? {
    didSet {
      unverifiedDisclaimerView.learnMoreTapped = learnMoreTapped
    }
  }
  
  // MARK: -
  
  private struct UX {
    static let faviconBackgroundColor = Colors.neutral800
    static let faviconSize = CGSize(width: 48.0, height: 48.0)
    static let faviconBorderColor = Colors.neutral800
    static let publisherNameColor = Colors.grey000
    static let verifiedStatusColor = Colors.grey200
  }
  
  // For containing the favicon and publisherStackView (Always visible)
  private let containerStackView = UIStackView().then {
    $0.spacing = 10.0
    $0.alignment = .center
  }
  
  // For containing the publisherNameLabel and verifiedLabelStackView (Always visible)
  private let publisherStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4.0
  }
  
  // For containing verificationSymbolImageView and verifiedLabel
  private let verifiedLabelStackView = UIStackView().then {
    $0.spacing = 4.0
  }
  // ✓ or ?
  private let verificationSymbolImageView = UIImageView().then {
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  // "Brave Verified Publisher" / "Not yet verified"
  private let verifiedLabel = UILabel().then {
    $0.textColor = UX.verifiedStatusColor
    $0.font = .systemFont(ofSize: 12.0)
    $0.adjustsFontSizeToFitWidth = true
  }
  // Only shown when unverified
  private let unverifiedDisclaimerView = DisclaimerView(text: BATLocalizedString("BraveRewardsUnverifiedPublisherDisclaimer", "This creator has not yet signed up to receive contributions from Brave users. Any tips you send will remain in your wallet until they verify."))
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    axis = .vertical
    spacing = 10.0
    
    addArrangedSubview(containerStackView)
    addArrangedSubview(unverifiedDisclaimerView)
    containerStackView.addArrangedSubview(faviconImageView)
    containerStackView.addArrangedSubview(publisherStackView)
    publisherStackView.addArrangedSubview(publisherNameLabel)
    publisherStackView.addArrangedSubview(verifiedLabelStackView)
    verifiedLabelStackView.addArrangedSubview(verificationSymbolImageView)
    verifiedLabelStackView.addArrangedSubview(verifiedLabel)
    
    faviconImageView.snp.makeConstraints {
      $0.size.equalTo(UX.faviconSize)
    }
  }
}
