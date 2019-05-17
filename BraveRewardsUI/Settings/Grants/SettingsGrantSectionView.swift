/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class SettingsGrantSectionView: SettingsSectionView {
  
  let claimGrantButton = Button().then {
    $0.loaderView = LoaderView(size: .small)
    $0.backgroundColor = BraveUX.braveOrange
    $0.tintColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
    $0.setTitle(Strings.SettingsGrantClaimButtonTitle.uppercased(), for: .normal)
    $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    clippedContentView.addSubview(claimGrantButton)
    clippedContentView.addSubview(iconImageView)
    clippedContentView.addSubview(textLabel)
    
    snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(48.0)
    }
    claimGrantButton.snp.makeConstraints {
      $0.top.bottom.trailing.equalTo(self)
    }
    iconImageView.snp.makeConstraints {
      $0.leading.centerY.equalTo(self.layoutMarginsGuide)
      $0.width.equalTo(iconImageView.image!.size.width * (2.0/3.0))
      $0.height.equalTo(iconImageView.snp.width)
    }
    textLabel.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(self.layoutMarginsGuide)
      $0.bottom.lessThanOrEqualTo(self.layoutMarginsGuide)
      $0.leading.equalTo(self.iconImageView.snp.trailing).offset(10.0)
      $0.trailing.equalTo(self.claimGrantButton.snp.leading).offset(-10.0)
      $0.centerY.equalTo(self)
    }
  }
  
  // MARK: - Private UI
  
  private let iconImageView = UIImageView(image: UIImage(frameworkResourceNamed: "icn-grant")).then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let textLabel = UILabel().then {
    $0.text = Strings.SettingsGrantText
    $0.textColor = SettingsUX.bodyTextColor
    $0.font = SettingsUX.bodyFont
    $0.numberOfLines = 0
  }
}
