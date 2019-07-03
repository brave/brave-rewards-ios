/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class PublisherView: UIStackView {
  
  func setVerificationStatusHidden(_ hidden: Bool) {
    verifiedLabelStackView.isHidden = hidden
  }
  
  func setVerified(_ status: Bool) {
    if status {
      verificationSymbolImageView.image = UIImage(frameworkResourceNamed: "icn-verify")
      verifiedLabel.text = Strings.Verified
      unverifiedDisclaimerView.isHidden = true
    } else {
      verificationSymbolImageView.image = UIImage(frameworkResourceNamed: "icn-unverified")
      verifiedLabel.text = Strings.NotYetVerified
      unverifiedDisclaimerView.isHidden = false
    }
  }
  
  let faviconImageView = PublisherIconCircleImageView(size: UX.faviconSize)
  
  let publisherNameLabel = UILabel().then {
    $0.textColor = UX.publisherNameColor
    $0.font = .systemFont(ofSize: 18.0, weight: .medium)
    $0.numberOfLines = 0
  }
  
  /// The learn more button on the unverified publisher disclaimer was tapped
  var learnMoreTapped: (() -> Void)? {
    didSet {
      unverifiedDisclaimerView.onLinkedTapped = { [weak self] _ in
        self?.learnMoreTapped?()
      }
    }
  }
  
  /// Refresh Publisher List
  var onCheckAgainTapped: (() -> Void)?
  
  // MARK: -
  
  private struct UX {
    static let faviconSize: CGFloat = 48
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
  
  // For containing verificationSymbolImageView and verifiedCheckAgainStackView
  private let verifiedLabelStackView = UIStackView().then {
    $0.spacing = 4.0
  }
  
  // ✓ or ?
  private let verificationSymbolImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private let verifiedCheckAgainStackView = UIStackView().then {
    $0.spacing = 4.0
  }
  
  // "Brave Verified Publisher" / "Not yet verified"
  private let verifiedLabel = UILabel().then {
    $0.textColor = UX.verifiedStatusColor
    $0.font = .systemFont(ofSize: 12.0)
    $0.adjustsFontSizeToFitWidth = true
  }
  
  let checkAgainButton = Button().then {
    $0.setTitleColor(Colors.blue500, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12.0)
    $0.setTitle(Strings.CheckAgain, for: .normal)
    $0.setContentHuggingPriority(.required, for: .horizontal)
    $0.loaderView = LoaderView(size: .small)
  }
  
  // Only shown when unverified
  private let unverifiedDisclaimerView = LinkLabel().then {
    $0.textColor = Colors.grey200
    $0.font = UIFont.systemFont(ofSize: 12.0)
    $0.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    $0.text = "\(Strings.UnverifiedPublisherDisclaimer) \(Strings.DisclaimerLearnMore)"
    $0.backgroundColor = UIColor(white: 0.0, alpha: 0.04)
    $0.layer.cornerRadius = 4.0
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
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
    verifiedLabelStackView.addArrangedSubview(verifiedCheckAgainStackView)
    verifiedCheckAgainStackView.addArrangedSubview(verifiedLabel)
    verifiedCheckAgainStackView.addArrangedSubview(checkAgainButton)
    
    faviconImageView.snp.makeConstraints {
      $0.size.equalTo(UX.faviconSize)
    }
    
    checkAgainButton.addTarget(self, action: #selector(onCheckAgainPressed(_:)), for: .touchUpInside)
  }
  
  @objc
  private func onCheckAgainPressed(_ button: Button) {
    onCheckAgainTapped?()
  }
}
