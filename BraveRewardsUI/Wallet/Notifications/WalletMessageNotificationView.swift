// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct WalletMessageNotification {
  struct Category {
    let icon: UIImage
    let title: String
    
    static let contribute = Category(
      icon: UIImage(frameworkResourceNamed: "icn-contribute"),
      title: Strings.NotificationAutoContributeTitle
    )
    static let tipsProcessed = Category(
      icon: UIImage(frameworkResourceNamed: "icn-contribute"),
      title: Strings.NotificationRecurringTipTitle
    )
    static let verifiedPublisher = Category(
      icon: UIImage(frameworkResourceNamed: "icn-contribute"),
      title: Strings.NotificationPendingContributionTitle
    )
  }
  let category: Category
  let body: String
  let date: Date
}

class WalletMessageNotificationView: WalletNotificationView {

  private let notification: WalletMessageNotification
  
  init(notification: WalletMessageNotification) {
    self.notification = notification
    super.init(frame: .zero)
    iconImageView.image = notification.category.icon
    let bodyLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.textAlignment = .center
      $0.attributedText = bodyAttributedString()
    }
    stackView.addArrangedSubview(bodyLabel)
  }

  private func bodyAttributedString() -> NSAttributedString {
    let string = NSMutableAttributedString()
    string.append(NSAttributedString(
      string: notification.category.title,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
        .foregroundColor: UIColor.black,
      ]
    ))
    string.append(NSAttributedString(string: "\n"))
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
