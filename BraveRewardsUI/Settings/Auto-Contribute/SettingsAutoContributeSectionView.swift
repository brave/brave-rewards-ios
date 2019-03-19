/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class SettingsAutoContributeSectionView: SettingsSectionView {
  
  private struct UX {
    static let titleColor = UIColor(hex: 0x90329C) // No close color in Brave palette
  }
  
  public let toggleSwitch = UISwitch().then {
    $0.onTintColor = BraveUX.switchOnColor
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  public let viewDetailsButton = SettingsViewDetailsButton(type: .system)
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    viewDetailsButton.hitTestSlop = UIEdgeInsets(top: -stackView.spacing, left: 0, bottom: -stackView.spacing, right: 0)
    
    addSubview(stackView)
    stackView.addArrangedSubview(toggleStackView)
    stackView.addArrangedSubview(bodyLabel)
    stackView.addArrangedSubview(viewDetailsButton)
    toggleStackView.addArrangedSubview(titleLabel)
    toggleStackView.addArrangedSubview(toggleSwitch)
    
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self.layoutMarginsGuide)
    }
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10.0
  }
  
  private let toggleStackView = UIStackView().then {
    $0.spacing = 10.0
  }
  
  private let titleLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSettingsAutoContributeTitle", "Auto-Contribute")
    $0.textColor = UX.titleColor
    $0.font = SettingsUX.titleFont
  }
  
  private let bodyLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSettingsAutoContributeBody", "An automatic way to support publishers and content creators. Set a monthly payment and browse normally. The sites you visit receive your contributions automatically, based on your attention as measured by Brave.")
    $0.textColor = SettingsUX.bodyTextColor
    $0.numberOfLines = 0
    $0.font = SettingsUX.bodyFont
  }
}
