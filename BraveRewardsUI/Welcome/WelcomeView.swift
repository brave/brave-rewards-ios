/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

extension WelcomeViewController {
  
  private class HeaderView: UIView {
    
    let createWalletButton = CreateWalletButton(titleText: BATLocalizedString("BraveRewardsLearnMoreCreateWallet1", "Yes, I'm In!").uppercased()).then {
      $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
      $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
    
    let backgroundView = GradientView.purpleRewardsGradientView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10.0
      }
      
      addSubview(backgroundView)
      addSubview(stackView)
      
      stackView.addStackViewItems(
        .view(UIImageView(image: UIImage(frameworkResourceNamed: "bat-dragable"))),
        .customSpace(20.0),
        .view(UILabel().then {
          $0.textColor = .white
          $0.font = .systemFont(ofSize: 28.0, weight: .medium)
          $0.textAlignment = .center
          $0.attributedText = {
            let title = NSMutableAttributedString(string: BATLocalizedString("BraveRewards", "Brave Rewards™"))
            if let trademarkRange = title.string.range(of: "™") {
              title.addAttributes(
                [
                  .font: UIFont.systemFont(ofSize: 14.0),
                  .baselineOffset: 10.0
                ],
                range: NSRange(trademarkRange, in: title.string)
              )
            }
            return title
          }()
        }),
        .view(UILabel().then {
          $0.textColor = Colors.blue500
          $0.font = .systemFont(ofSize: 22.0)
          $0.textAlignment = .center
          $0.numberOfLines = 0
          $0.text = BATLocalizedString("BraveRewardsLearnMoreSubtitle", "Get Rewarded for Browsing!")
        }),
        .customSpace(15.0),
        .view(UILabel().then {
          $0.textColor = .white
          $0.font = .systemFont(ofSize: 16.0)
          $0.textAlignment = .center
          $0.numberOfLines = 0
          $0.text = BATLocalizedString("BraveRewardsLearnMoreBody", "Earn tokens for viewing privacy-respecting ads, and pay it forward by supporting content creators you love!")
        }),
        .customSpace(25.0),
        .view(createWalletButton),
        .customSpace(25.0),
        .view(UILabel().then {
          $0.text = BATLocalizedString("BraveRewardsLearnMoreHowItWorks", "How it works…")
          $0.textColor = UIColor(white: 1.0, alpha: 0.5)
          $0.textAlignment = .center
          $0.font = .systemFont(ofSize: 16.0)
        }),
        .view(UIImageView(image: UIImage(frameworkResourceNamed: "learn-more-arrow").alwaysTemplate).then {
          $0.tintColor = .white
          $0.alpha = 0.5
        })
      )
      
      createWalletButton.snp.makeConstraints {
        $0.leading.trailing.equalTo(self).inset(50.0)
        $0.height.equalTo(40.0)
      }
      stackView.snp.makeConstraints {
        $0.edges.equalTo(layoutMarginsGuide).inset(20.0)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
    
    func roundedBottomPath() -> UIBezierPath {
      let path = UIBezierPath()
      path.move(to: .zero)
      path.addLine(to: CGPoint(x: 0, y: bounds.maxY - 20))
      path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.maxY - 20), controlPoint: CGPoint(x: bounds.midX, y: bounds.maxY))
      path.addLine(to: CGPoint(x: bounds.maxX, y: 0))
      path.close()
      return path
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      
      backgroundView.frame = bounds
      layer.mask = CAShapeLayer().then {
        $0.path = roundedBottomPath().cgPath
      }
    }
  }
  
  private class FeatureBlockView: UIView {
    
    init(icon: UIImage, title: String, body: String) {
      super.init(frame: .zero)
      
      backgroundColor = .white
      layer.cornerRadius = 5.0
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.1
      layer.shadowRadius = 1.5
      layer.shadowOffset = CGSize(width: 0, height: 1)
      
      let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 15.0
      }
      
      addSubview(stackView)
      stackView.addArrangedSubview(UIImageView(image: icon))
      stackView.addArrangedSubview(UILabel().then {
        $0.text = title
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18, weight: .medium)
      })
      stackView.addArrangedSubview(UILabel().then {
        $0.text = body
        $0.textColor = Colors.grey200
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16)
      })
      
      stackView.snp.makeConstraints {
        $0.edges.equalTo(self).inset(30)//UIEdgeInsets(top: 45, left: 30, bottom: 45, right: 30))
      }
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      
      layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
  
  class View: UIView {
    
    let createWalletButton = CreateWalletButton(titleText: BATLocalizedString("BraveRewardsLearnMoreCreateWallet2", "Yes I'm Ready!").uppercased()).then {
      $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
      $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
      $0.backgroundColor = BraveUX.braveOrange
      $0.layer.borderWidth = 0
    }
    
    private let headerView = HeaderView()
    
    private(set) lazy var createWalletButtons: [CreateWalletButton] = [
      headerView.createWalletButton,
      createWalletButton
    ]
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.delaysContentTouches = false
      }
      
      let stackView = UIStackView().then {
        $0.axis = .vertical
      }
      
      // No color matching with the pallette...
      backgroundColor = UIColor(hex: 0xF8FAFF)
      
      addSubview(scrollView)
      scrollView.addSubview(stackView)
      
      let contentStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 40, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 15.0
      }
      
      stackView.addArrangedSubview(headerView)
      stackView.addArrangedSubview(contentStackView)
      
      contentStackView.addStackViewItems(
        .view(UILabel().then {
          $0.text = BATLocalizedString("BraveRewardsLearnMoreWhyTitle", "Why Brave Rewards?")
          $0.font = .systemFont(ofSize: 24.0)
          $0.textColor = .black
          $0.numberOfLines = 0
        }),
        .customSpace(10.0),
        .view(UILabel().then {
          $0.text = BATLocalizedString("BraveRewardsLearnMoreWhyBody", "With conventional browsers, you pay to browse the web by viewing ads with your valuable attention, spending your valuable time downloading invasive ad technology, that transmits your valuable private data to advertisers — without your consent.\n\nWell, you've come to the right place. Brave welcomes you to the new internet. One where your time is valued, your personal data is kept private, and you actually get paid for your attention.")
          $0.font = .systemFont(ofSize: 16.0)
          $0.textColor = Colors.grey200
          $0.numberOfLines = 0
        }),
        .customSpace(20.0),
        .view(FeatureBlockView(
          icon: UIImage(frameworkResourceNamed: "turn-on-rewards"),
          title: BATLocalizedString("BraveRewardsLearnMoreTurnOnRewardsTitle", "Turn on Rewards"),
          body: BATLocalizedString("BraveRewardsLearnMoreTurnOnRewardsBody", "This enables both Brave Ads and Auto-Contribute. You can always opt out each any time.")
        )),
        .view(FeatureBlockView(
          icon: UIImage(frameworkResourceNamed: "ads-graphic"),
          title: BATLocalizedString("BraveRewardsLearnMoreBraveAdsTitle", "Brave Ads"),
          body: BATLocalizedString("BraveRewardsLearnMoreBraveAdsBody", "No action required. Just collect tokens. Your data is safe with our Shields.")
        )),
        .view(FeatureBlockView(
          icon: UIImage(frameworkResourceNamed: "send-tips"),
          title: BATLocalizedString("BraveRewardsLearnMoreTipsTitle", "Auto-Contribute"),
          body: BATLocalizedString("BraveRewardsLearnMoreTipsBody", "Set budget and browse normally. Your favorite sites get paid automatically.")
        )),
        .customSpace(40.0),
        .view(UILabel().then {
          $0.text = BATLocalizedString("BraveRewardsLearnMoreReady", "Ready to get started?")
          $0.font = .systemFont(ofSize: 20.0)
          $0.textAlignment = .center
          $0.textColor = Colors.blurple400
          $0.numberOfLines = 0
        }),
        .customSpace(20.0),
        .view(UIStackView().then { stackView in
          stackView.alignment = .center
          stackView.axis = .vertical
          stackView.addArrangedSubview(createWalletButton)
          createWalletButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(stackView).inset(30)
            $0.height.equalTo(40.0)
          }
        })
      )
      
      scrollView.snp.makeConstraints {
        $0.edges.equalTo(self)
      }
      scrollView.contentLayoutGuide.snp.makeConstraints {
        $0.width.equalTo(self)
      }
      stackView.snp.makeConstraints {
        $0.edges.equalTo(scrollView.contentLayoutGuide)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}
