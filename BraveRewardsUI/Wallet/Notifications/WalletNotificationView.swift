/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

struct WalletNotification {
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

class WalletNotificationView: UIView {
  
  let closeButton = Button()
  
  let backgroundView = UIImageView(image: UIImage(frameworkResourceNamed: "notification_header"))
  let iconImageView = UIImageView(image: nil).then {
    $0.setContentHuggingPriority(.required, for: .horizontal)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  let stackView = UIStackView()
  private let notification: WalletNotification?
  
  override init(frame: CGRect) {
    self.notification = nil
    super.init(frame: frame)
    commonSetup()
  }
  
  init(notification: WalletNotification) {
    self.notification = notification
    super.init(frame: .zero)
    commonSetup()
    iconImageView.image = notification.category.icon
    let bodyLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.textAlignment = .center
      $0.attributedText = bodyAttributedString()
    }
    stackView.addArrangedSubview(bodyLabel)
  }
  
  private func commonSetup() {
    backgroundColor = .clear
    
    closeButton.do {
      $0.setImage(UIImage(frameworkResourceNamed: "close-icon").alwaysTemplate, for: .normal)
      $0.tintColor = Colors.grey300
      $0.contentMode = .center
    }
    
    addSubview(backgroundView)
    addSubview(closeButton)
    addSubview(stackView)
    stackView.addArrangedSubview(iconImageView)
    
    closeButton.snp.makeConstraints {
      $0.top.trailing.equalTo(safeAreaLayoutGuide)
      $0.width.height.equalTo(44.0)
    }
    
    stackView.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(self).offset(15.0)
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(35.0)
      $0.bottom.lessThanOrEqualTo(self).inset(25.0)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundView.frame = bounds
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  private func bodyAttributedString() -> NSAttributedString {
    guard let notification = notification else {
      return NSAttributedString()
    }
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
