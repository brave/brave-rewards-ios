/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

public class WalletHeader: UIView {
  
  let backgroundImageView = UIImageView().then {
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
  }
  
  let titleLabel = UILabel()
  let balanceLabel = UILabel()
  let altcurrencyTypeLabel = UILabel()
  let altcurrencyContainerView = UIStackView()
  let usdBalanceLabel = UILabel()
  let grantsButton = ActionButton()
  let addFundsButton = UIButton()
  let settingsButton = UIButton()
  let buttonsContainerView = UIStackView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    
    addSubview(backgroundImageView)
    addSubview(titleLabel)
    addSubview(altcurrencyTypeLabel)
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
    altcurrencyTypeLabel.snp.makeConstraints {
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
