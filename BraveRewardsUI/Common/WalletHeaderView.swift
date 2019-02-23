/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

public class WalletHeaderView: UIView {
  
  let backgroundImageView = UIImageView().then {
    $0.image = UIImage(frameworkResourceNamed: "header")
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
  }
  
  let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16.0, weight: .medium)
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.text = BATLocalizedString("BraveRewardsWalletHeaderTitle", "Your Wallet")
  }
  
  let altcurrencyContainerView = UIStackView().then {
    $0.spacing = 4.0
    $0.alignment = .lastBaseline
  }
  
  public let balanceLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 36.0)
  }
  
  public let altcurrencyTypeLabel = UILabel().then {
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.font = .systemFont(ofSize: 18.0)
  }
  
  public let usdBalanceLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.font = .systemFont(ofSize: 12.0)
  }
  
  public let grantsButton = ActionButton(type: .system).then {
    $0.flipImageOrigin = true
    $0.titleLabel?.font = .systemFont(ofSize: 10.0, weight: .semibold)
    $0.setImage(UIImage(frameworkResourceNamed: "down-arrow"), for: .normal)
    $0.setTitle(BATLocalizedString("BraveRewardsWalletHeaderGrants", "Grants"), for: .normal)
    $0.setTitleColor(UIColor(white: 1.0, alpha: 0.75), for: .normal)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5.0)
    $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10.0)
  }
  
  let addFundsButton = UIButton(type: .system).then {
    $0.setTitleColor(UIColor(white: 1.0, alpha: 0.75), for: .normal)
    $0.setTitle(BATLocalizedString("BraveRewardsAddFunds", "Add Funds"), for: .normal)
    $0.setImage(UIImage(frameworkResourceNamed: "wallet-icon").alwaysOriginal, for: .normal)
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8.0)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8.0)
    $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
    $0.titleLabel?.font = .systemFont(ofSize: 14.0)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  let settingsButton = UIButton(type: .system).then {
    $0.setTitleColor(UIColor(white: 1.0, alpha: 0.75), for: .normal)
    $0.setTitle(BATLocalizedString("BraveRewardsSettings", "Settings"), for: .normal)
    $0.setImage(UIImage(frameworkResourceNamed: "bat").alwaysOriginal, for: .normal)
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8.0)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8.0)
    $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
    $0.titleLabel?.font = .systemFont(ofSize: 14.0)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  let buttonsContainerView = UIStackView().then {
    $0.spacing = 20.0
    $0.alignment = .center
    $0.distribution = .fillEqually
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    
    addSubview(backgroundImageView)
    addSubview(titleLabel)
    addSubview(altcurrencyContainerView)
    altcurrencyContainerView.addArrangedSubview(balanceLabel)
    altcurrencyContainerView.addArrangedSubview(altcurrencyTypeLabel)
    addSubview(usdBalanceLabel)
    addSubview(grantsButton)
    addSubview(buttonsContainerView)
    buttonsContainerView.addArrangedSubview(addFundsButton)
    buttonsContainerView.addArrangedSubview(settingsButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self).inset(15.0)
    }
    altcurrencyContainerView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
      $0.centerX.equalTo(self)
      $0.leading.greaterThanOrEqualTo(self).offset(20.0)
      $0.trailing.lessThanOrEqualTo(self).offset(-20.0)
    }
    usdBalanceLabel.snp.makeConstraints {
      $0.top.equalTo(self.altcurrencyTypeLabel.snp.bottom).offset(4.0)
      $0.centerX.equalTo(self)
      $0.leading.greaterThanOrEqualTo(self).offset(20.0)
      $0.trailing.lessThanOrEqualTo(self).offset(-20.0)
    }
    grantsButton.snp.makeConstraints {
      $0.top.equalTo(self.usdBalanceLabel.snp.bottom).offset(12.0)
      $0.centerX.equalTo(self)
      $0.height.equalTo(26.0)
      $0.leading.greaterThanOrEqualTo(self).offset(20.0)
      $0.trailing.lessThanOrEqualTo(self).offset(-20.0)
    }
    buttonsContainerView.snp.makeConstraints {
      $0.top.equalTo(self.grantsButton.snp.bottom).offset(20.0)
      $0.leading.trailing.bottom.equalTo(self).inset(30.0)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundImageView.frame = bounds
  }
}
