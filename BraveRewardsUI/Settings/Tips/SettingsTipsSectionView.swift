/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class SettingsTipsSectionView: SettingsSectionView {
  
  private struct UX {
    static let titleColor = UIColor(hex: 0x6A71D5) // No close color in Brave palette
  }
  
  @objc public func setSectionEnabled(_ enabled: Bool, animated: Bool = false) {
    if animated {
      if enabled {
        viewDetailsButton.alpha = 0.0
      }
      UIView.animate(withDuration: 0.15) {
        self.viewDetailsButton.isHidden = !enabled
        self.viewDetailsButton.alpha = enabled ? 1.0 : 0.0
      }
    } else {
      viewDetailsButton.isHidden = !enabled
    }
  }
  
  @objc public let viewDetailsButton = SettingsViewDetailsButton(type: .system)
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
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
    $0.text = BATLocalizedString("BraveRewardsSettingsTipsTitle", "Tips")
    $0.textColor = UX.titleColor
    $0.font = SettingsUX.titleFont
  }
  
  private let bodyLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSettingsTipsBody", "Tip content creators directly as you browse. You can also set up recurring monthly tips so you can support sites continuously.")
    $0.textColor = SettingsUX.bodyTextColor
    $0.numberOfLines = 0
    $0.font = SettingsUX.bodyFont
  }
}
