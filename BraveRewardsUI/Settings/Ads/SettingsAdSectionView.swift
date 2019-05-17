/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class SettingsAdSectionView: SettingsSectionView {
  
  private struct UX {
    static let comingSoonTextColor = UIColor(hex: 0xC9B5DE) // Has to match icon color (which has no close color)
  }
  
  let viewDetailsButton = SettingsViewDetailsButton(type: .system)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    viewDetailsButton.hitTestSlop = UIEdgeInsets(top: -stackView.spacing, left: 0, bottom: -stackView.spacing, right: 0)
    
    addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(bodyLabel)
    stackView.addArrangedSubview(viewDetailsButton)
    
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self.layoutMarginsGuide)
    }
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10.0
  }
  
  private let titleLabel = UILabel().then {
    $0.text = Strings.SettingsAdsTitle
    $0.textColor = BraveUX.adsTintColor
    $0.font = SettingsUX.titleFont
  }

  private let bodyLabel = UILabel().then {
    $0.text = Strings.SettingsAdsBody
    $0.textColor = SettingsUX.bodyTextColor
    $0.numberOfLines = 0
    $0.font = SettingsUX.bodyFont
  }
}
