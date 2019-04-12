/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class AutoContributeCell: UITableViewCell, TableViewReusable {
  
  private let siteStackView = UIStackView()
  
  
  var attentionAmount: CGFloat = 0.0 {
    didSet {
      attentionBackgroundFillView.snp.remakeConstraints {
        $0.trailing.equalTo(contentView)
        $0.top.bottom.equalTo(contentView)
        $0.width.equalTo(self).multipliedBy(attentionAmount)
      }
      attentionLabel.text = String(format: "%ld%%", Int(attentionAmount * 100))
    }
  }
  
  private let attentionBackgroundFillView = UIView().then {
    $0.backgroundColor = Colors.blurple800
  }
  
  let siteImageView = UIImageView().then {
    $0.setContentHuggingPriority(.required, for: .horizontal)
    $0.contentMode = .scaleAspectFit
    $0.snp.makeConstraints {
      $0.width.height.equalTo(28.0)
    }
  }
  let verifiedStatusImageView = UIImageView(image: UIImage(frameworkResourceNamed: "icn-verify")).then {
    $0.isHidden = true
  }
  let siteNameLabel = UILabel().then {
    $0.textColor = SettingsUX.bodyTextColor
    $0.font = SettingsUX.bodyFont
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    $0.numberOfLines = 0
  }
  private let attentionLabel = UILabel().then {
    $0.textColor = Colors.grey200
    $0.font = SettingsUX.bodyFont
    $0.textAlignment = .right
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: nil)
    
    siteStackView.spacing = verifiedStatusImageView.image?.size.width ?? 10.0
    
    backgroundView = attentionBackgroundFillView
    contentView.addSubview(siteStackView)
    contentView.addSubview(attentionLabel)
    contentView.addSubview(verifiedStatusImageView)
    siteStackView.addArrangedSubview(siteImageView)
    siteStackView.addArrangedSubview(siteNameLabel)
    
    siteStackView.snp.makeConstraints {
      $0.leading.top.bottom.equalTo(layoutMarginsGuide)
      $0.trailing.lessThanOrEqualTo(attentionLabel.snp.leading).offset(-10.0)
    }
    verifiedStatusImageView.snp.makeConstraints {
      $0.top.equalTo(layoutMarginsGuide)
      $0.leading.equalTo(siteImageView.snp.trailing).offset(-4.0)
    }
    attentionLabel.snp.makeConstraints {
      $0.trailing.equalTo(layoutMarginsGuide)
      $0.centerY.equalTo(contentView)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  
  // MARK: - Unavailable
  
  @available(*, unavailable)
  override var textLabel: UILabel? {
    get { return super.textLabel }
    set { }
  }
  
  @available(*, unavailable)
  override var detailTextLabel: UILabel? {
    get { return super.detailTextLabel }
    set { }
  }
  
  @available(*, unavailable)
  override var imageView: UIImageView? {
    get { return super.imageView }
    set { }
  }
}
