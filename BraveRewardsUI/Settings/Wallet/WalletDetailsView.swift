/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

extension WalletDetailsViewController {
  class View: UIView {
    
    let walletSection = SettingsWalletSectionView(buttonType: .addFunds)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      backgroundColor = SettingsUX.backgroundColor
      
      // FIXME: Remove temp values
      walletSection.setWalletBalance("30", crypto: "BAT", dollarValue: "0.00 USD")
      
      addSubview(scrollView)
      scrollView.addSubview(stackView)
      stackView.addArrangedSubview(walletSection)
      //    stackView.addArrangedSubview(EmptyWalletView())
      stackView.addArrangedSubview(WalletActivityView())
      stackView.addArrangedSubview(PoweredByUpholdView())
      
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
}

extension WalletDetailsViewController.View {
  /// What is shown when the user has an empty balance.
  private class EmptyWalletView: SettingsSectionView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      let imageView = UIImageView(image: UIImage(frameworkResourceNamed: "icn-blankslate-statement"))
      let titleLabel = UILabel().then {
        $0.text = BATLocalizedString("BraveRewardsEmptyWalletTitle", "Sorry, no tokens yet.")
        $0.textColor = SettingsUX.bodyTextColor
        $0.font = .systemFont(ofSize: 22.0)
        $0.textAlignment = .center
        $0.numberOfLines = 0
      }
      
      /// Left-aligned bullet-points stack view
      class BulletPointStackView: UIStackView {
        override init(frame: CGRect) {
          super.init(frame: frame)
          axis = .vertical
          spacing = 4.0
          alignment = .leading
          
          addArrangedSubview(UILabel().then {
            $0.font = .systemFont(ofSize: 15.0, weight: .medium)
            $0.textColor = SettingsUX.subtitleTextColor
            $0.text = BATLocalizedString("BraveRewardsEmptyWalletBulletHeader", "3 ways to fill your wallet:")
          })
          addArrangedSubview(UILabel().then {
            $0.font = .systemFont(ofSize: 15.0)
            $0.textColor = SettingsUX.bodyTextColor
            $0.text = BATLocalizedString("BraveRewardsEmptyWalletBulletPoints", "• You can add funds.\n• You can earn tokens from viewing ads.\n• Occasionally, you'll be offered free token grants from Brave. Be sure to keep an eye out for the alert!")
            $0.numberOfLines = 0
          })
        }
        @available(*, unavailable)
        required init(coder: NSCoder) {
          fatalError()
        }
      }
      
      let bulletPointStackView = BulletPointStackView()
      
      addSubview(imageView)
      addSubview(titleLabel)
      addSubview(bulletPointStackView)
      
      imageView.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self).offset(20.0)
      }
      titleLabel.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview().inset(30.0)
        $0.top.equalTo(imageView.snp.bottom).offset(30.0)
      }
      bulletPointStackView.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview().inset(40.0)
        $0.top.equalTo(titleLabel.snp.bottom).offset(30.0)
        $0.bottom.equalToSuperview().inset(20.0)
      }
    }
  }
  
  /// "{icon} Your Brave wallet is managed by Uphold" view
  private class PoweredByUpholdView: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      let stackView = UIStackView().then {
        $0.spacing = 6.0
        $0.alignment = .center
      }
      let upholdImage = UIImage(frameworkResourceNamed: "uphold").alwaysTemplate
      stackView.addArrangedSubview(UIImageView(image: upholdImage).then {
        $0.tintColor = Colors.grey300
        $0.setContentHuggingPriority(.required, for: .horizontal)
      })
      stackView.addArrangedSubview(UILabel().then {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.textColor = Colors.grey300
        $0.font = .systemFont(ofSize: 14.0)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.attributedText = {
          let s = NSMutableAttributedString(string: BATLocalizedString("BraveRewardsPoweredByUphold", "Your Brave wallet is managed by Uphold"))
          if let upholdRange = s.string.range(of: "Uphold") {
            s.addAttribute(
              .font,
              value: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
              range: NSRange(upholdRange, in: s.string)
            )
          }
          return s
        }()
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
          $0.leading.greaterThanOrEqualToSuperview().inset(10)
          $0.trailing.lessThanOrEqualToSuperview().inset(10)
          $0.centerX.equalToSuperview()
          $0.top.bottom.equalToSuperview().inset(5.0)
        }
      })
    }
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}
