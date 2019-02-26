/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

public class RewardsDisabledView: UIView {
  
  @objc public var enableRewardsButton: UIButton {
    return contentView.enableRewardsButton
  }
  
  private let gradientView = GradientView.softBlueToClearGradientView()
  let scrollView = UIScrollView().then {
    $0.contentInsetAdjustmentBehavior = .never
    $0.delaysContentTouches = false
  }
  private let contentView = ContentView()
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(gradientView)
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.contentLayoutGuide.snp.makeConstraints {
      $0.width.equalTo(self)
      $0.bottom.equalTo(self.contentView)
    }
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    gradientView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    contentView.snp.makeConstraints {
      $0.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
      $0.leading.trailing.equalTo(self)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}

extension RewardsDisabledView: WalletContentView {
  public var displaysRewardsSummaryButton: Bool {
    return false
  }
  
  public var innerScrollView: UIScrollView? {
    return scrollView
  }
}

extension RewardsDisabledView {
  fileprivate class ContentView: UIView {
    private struct UX {
      static let titleColor = Colors.grey100
      static let subtitleColor = Colors.blurple400
      static let bodyColor = Colors.grey100
      static let rewardsButtonTintColor = Colors.blurple400
      static let rewardsButtonHeight = 40.0
    }
    
    let batLogoImageView = UIImageView(image: UIImage(frameworkResourceNamed: "bat-logo")).then {
      $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    let titleLabel = UILabel().then {
      $0.font = .systemFont(ofSize: 28.0)
      $0.textColor = UX.titleColor
      $0.textAlignment = .center
      $0.text = BATLocalizedString("BraveRewardsDisabledTitle", "Welcome back!")
    }
    
    let subtitleLabel = UILabel().then {
      $0.font = .systemFont(ofSize: 18.0, weight: .semibold)
      $0.textColor = UX.subtitleColor
      $0.textAlignment = .center
      $0.numberOfLines = 0
      $0.text = BATLocalizedString("BraveRewardsDisabledSubtitle", "Get rewarded for browsing.")
    }
    
    let bodyLabel = UILabel().then {
      $0.font = .systemFont(ofSize: 16.0)
      $0.textColor = UX.bodyColor
      $0.textAlignment = .center
      $0.numberOfLines = 0
      $0.text = BATLocalizedString("BraveRewardsDisabledBody", "Earn by viewing privacy-respecting ads, and pay it forward to support content creators you love.")
    }
    
    let enableRewardsButton = ActionButton(type: .system).then {
      $0.setTitle(BATLocalizedString("BraveRewardsDisabledEnableButton", "Enable Brave Rewards".uppercased()), for: .normal)
      $0.setImage(UIImage(frameworkResourceNamed: "continue-button-arrow").alwaysOriginal, for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .semibold)
      $0.tintColor = UX.rewardsButtonTintColor
      $0.flipImageOrigin = true
      $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5.0)
      $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(batLogoImageView)
      addSubview(titleLabel)
      addSubview(subtitleLabel)
      addSubview(bodyLabel)
      addSubview(enableRewardsButton)
      
      batLogoImageView.snp.makeConstraints {
        $0.top.equalTo(self).offset(10.0)
        $0.centerX.equalTo(self)
      }
      titleLabel.snp.makeConstraints {
        $0.top.equalTo(self.batLogoImageView.snp.bottom).offset(10.0)
        $0.leading.trailing.equalTo(self).inset(20.0)
      }
      subtitleLabel.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
        $0.leading.trailing.equalTo(self.titleLabel)
      }
      bodyLabel.snp.makeConstraints {
        $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(10.0)
        $0.leading.trailing.equalTo(self).inset(40.0)
      }
      enableRewardsButton.snp.makeConstraints {
        $0.top.greaterThanOrEqualTo(self.bodyLabel.snp.bottom).offset(30.0)
        $0.leading.trailing.equalTo(self).inset(40.0)
        $0.height.equalTo(UX.rewardsButtonHeight)
        $0.bottom.equalTo(self).offset(-25.0)
      }
    }
  }
}
