/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class SettingsAdSectionView: SettingsSectionView {
  
  private struct UX {
    static let comingSoonTextColor = UIColor(hex: 0xC9B5DE) // Has to match icon color (which has no close color)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(bodyLabel)
    stackView.addArrangedSubview(comingSoonView)
    
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
  
  private let comingSoonView = ComingSoonView()
}

extension SettingsAdSectionView {
  private class ComingSoonView: UIView {
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(comingSoonStackView)
      comingSoonStackView.addArrangedSubview(comingSoonImageView)
      comingSoonStackView.addArrangedSubview(comingSoonLabel)
      
      comingSoonStackView.snp.makeConstraints {
        $0.centerX.equalTo(self)
        $0.leading.greaterThanOrEqualTo(self)
        $0.trailing.lessThanOrEqualTo(self)
        $0.top.bottom.equalTo(self).inset(10.0)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
    
    private let comingSoonStackView = UIStackView().then {
      $0.alignment = .center
      $0.spacing = 20.0
    }
    
    private let comingSoonImageView = UIImageView(image: UIImage(frameworkResourceNamed: "ads-graphic")).then {
      $0.setContentHuggingPriority(UILayoutPriority(rawValue: 999.0), for: .horizontal)
      $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let comingSoonLabel = UILabel().then {
      $0.textColor = UX.comingSoonTextColor
      $0.font = .systemFont(ofSize: 17.0, weight: .medium)
      $0.numberOfLines = 0
      $0.setContentCompressionResistancePriority(.required, for: .horizontal)
      $0.text = Strings.SettingsAdsComingSoonText
    }
  }
}
