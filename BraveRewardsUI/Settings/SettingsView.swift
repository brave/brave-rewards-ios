/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

struct SettingsUX {
  static let backgroundColor = Colors.neutral800
  static let headerTextColor = Colors.grey100
  static let bodyTextColor = Colors.grey300
  static let disabledSectionTitleColor = Colors.grey300
  
  static let titleFont = UIFont.systemFont(ofSize: 16.0, weight: .bold)
  static let bodyFont = UIFont.systemFont(ofSize: 14.0)
  
  static let layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
}

public class SettingsView: UIView {
  
  @objc public let rewardsToggleSection = RewardsToggleSectionView()
  @objc public let adsSection = SettingsAdSectionView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = SettingsUX.backgroundColor
    
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(rewardsToggleSection)
    stackView.addArrangedSubview(adsSection)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    scrollView.contentLayoutGuide.snp.makeConstraints {
      $0.width.equalTo(self)
    }
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self.scrollView.contentLayoutGuide).inset(10.0)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Private UI
  
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.delaysContentTouches = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10.0
  }
}
