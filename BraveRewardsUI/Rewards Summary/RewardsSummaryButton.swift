/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

//extension RewardsSummaryView {
  public class RewardsSummaryViewButton: UIControl {
    
    private struct UX {
      static let backgroundColor = Colors.blurple800
      static let titleTextColor = Colors.blurple600
    }
    
    let titleLabel = UILabel().then {
      $0.text = BATLocalizedString("BraveRewardsSummaryTitle", "Rewards Summary").uppercased()
      $0.textColor = UX.titleTextColor
      $0.font = .systemFont(ofSize: 14.0, weight: .bold)
    }
    
    /// Should be set to "slide-up"/"slide-down" image based on slide status; Defaults to "slide-up"
    public let slideToggleImageView = UIImageView(image: UIImage(frameworkResourceNamed: "slide-up")).then {
      $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    public override init(frame: CGRect) {
      super.init(frame: frame)
      
      backgroundColor = UX.backgroundColor
      
      let paddingGuide = UILayoutGuide()
      addLayoutGuide(paddingGuide)
      
      addSubview(titleLabel)
      addSubview(slideToggleImageView)
      
      paddingGuide.snp.makeConstraints {
        $0.top.bottom.equalTo(self).inset(15.0)
        $0.leading.trailing.equalTo(self).inset(22.0)
      }
      titleLabel.snp.makeConstraints {
        $0.top.bottom.leading.equalTo(paddingGuide)
        $0.trailing.lessThanOrEqualTo(self.slideToggleImageView.snp.leading).offset(-20.0)
      }
      slideToggleImageView.snp.makeConstraints {
        $0.centerY.trailing.equalTo(paddingGuide)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
//}