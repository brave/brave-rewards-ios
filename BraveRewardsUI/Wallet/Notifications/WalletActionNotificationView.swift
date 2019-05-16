/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

struct WalletActionNotification {
  struct Category {
    let icon: UIImage
    let title: String
    let action: String
    
    static let adsRewards = Category(
      icon: UIImage(frameworkResourceNamed: "icn-ads"),
      title: Strings.BraveRewardsNotificationAdsTitle,
      action: Strings.CLAIM.uppercased()
    )
    static let autoContribute = Category(
      icon: UIImage(frameworkResourceNamed: "icn-contribute"),
      title: Strings.BraveRewardsNotificationAutoContributeTitle,
      action: Strings.OK.uppercased()
    )
    static let tokenGrant = Category(
      icon: UIImage(frameworkResourceNamed: "icn-grant"),
      title: Strings.BraveRewardsNotificationTokenGrantTitle,
      action: Strings.CLAIM.uppercased()
    )
    static let recurringTip = Category(
      icon: UIImage(frameworkResourceNamed: "icn-contribute"),
      title: Strings.BraveRewardsNotificationRecurringTipTitle,
      action: Strings.OK.uppercased()
    )
  }
  
  let category: Category
  let body: String
  let date: Date
}

class WalletActionNotificationView: WalletNotificationView {
  
  let notification: WalletActionNotification
  
  let actionButton = ActionButton()
  
  init(notification: WalletActionNotification) {
    self.notification = notification
    
    super.init(frame: .zero)
    
    let stackView = UIStackView().then {
      $0.axis = .vertical
      $0.alignment = .center
      $0.spacing = 15.0
    }
    
    let imageView = UIImageView(image: notification.category.icon)
    let bodyLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.textAlignment = .center
      $0.attributedText = bodyAttributedString()
    }
    actionButton.do {
      $0.backgroundColor = BraveUX.braveOrange
      $0.layer.borderWidth = 0.0
      $0.setTitle(notification.category.action, for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
      $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 13, bottom: 6, right: 13)
    }
    
    addSubview(stackView)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(bodyLabel)
    stackView.setCustomSpacing(15.0, after: bodyLabel)
    stackView.addArrangedSubview(actionButton)
    
    stackView.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(self).offset(15.0)
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(35.0)
      $0.bottom.lessThanOrEqualTo(self).inset(25.0)
    }
  }
  
  /// Forms the body string: "{title} | {body} {short-date}"
  private func bodyAttributedString() -> NSAttributedString {
    let string = NSMutableAttributedString()
    string.append(NSAttributedString(
      string: notification.category.title,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
        .foregroundColor: UIColor.black,
      ]
    ))
    string.append(NSAttributedString(
      string: " | ",
      attributes: [
        .font: UIFont.systemFont(ofSize: 14.0),
        .foregroundColor: UIColor.gray,
      ]
    ))
    string.append(NSAttributedString(
      string: notification.body,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14.0),
        .foregroundColor: Colors.grey100,
      ]
    ))
    string.append(NSAttributedString(
      string: " ",
      attributes: [ .font: UIFont.systemFont(ofSize: 14.0) ]
    ))
    let dateFormatter = DateFormatter().then {
      $0.dateFormat = "MMM d"
    }
    string.append(NSAttributedString(
      string: dateFormatter.string(from: notification.date),
      attributes: [
        .font: UIFont.systemFont(ofSize: 14.0),
        .foregroundColor: Colors.grey200,
      ]
    ))
    return string
  }
}
