/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class TippingConfirmationView: UIView {
  struct UX {
    static let backgroundColor = Colors.blurple000.withAlphaComponent(0.85)
    static let faviconBackgroundColor = Colors.neutral800
    static let faviconSize = CGSize(width: 92.0, height: 92.0)
    static let confirmationTextColor = Colors.grey600
  }
  
  let stackView = UIStackView().then {
    $0.alignment = .center
    $0.axis = .vertical
    $0.spacing = 20.0
  }
  
  let faviconImageView = UIImageView().then {
    $0.backgroundColor = UX.faviconBackgroundColor
    $0.clipsToBounds = true
    $0.layer.cornerRadius = UX.faviconSize.width / 2.0
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2.0
  }
  
  let confirmationLabel = UILabel().then {
    $0.text = Strings.BraveRewardsTippingConfirmation
    $0.textColor = UX.confirmationTextColor
    $0.font = .systemFont(ofSize: 25.0, weight: .bold)
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UX.backgroundColor
    
    addSubview(stackView)
    stackView.addArrangedSubview(faviconImageView)
    stackView.addArrangedSubview(confirmationLabel)
    
    stackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self).inset(20.0)
      $0.centerY.equalTo(self)
      $0.top.greaterThanOrEqualTo(self).offset(20.0)
      $0.bottom.lessThanOrEqualTo(self).offset(-20.0)
    }
    
    faviconImageView.snp.makeConstraints {
      $0.size.equalTo(UX.faviconSize)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}
