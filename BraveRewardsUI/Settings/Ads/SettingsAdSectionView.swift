/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class SettingsAdSectionView: SettingsSectionView {
  
  private struct UX {
    static let titleColor = UIColor(hex: 0xB13677) // No close color in Brave palette
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(bodyLabel)
    
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self.layoutMarginsGuide)
    }
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10.0
  }
  
  private let titleLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSettingsAdsTitle", "Ads")
    $0.textColor = UX.titleColor
    $0.font = SettingsUX.titleFont
  }

  private let bodyLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSettingsAdsBody", "Earn tokens by viewing ads in Brave. Ads presented are based on your interests, as inferred from your browsing behavior. No personal data or browsing history ever leaves your browser.")
    $0.textColor = SettingsUX.bodyTextColor
    $0.numberOfLines = 0
    $0.font = SettingsUX.bodyFont
  }
}
