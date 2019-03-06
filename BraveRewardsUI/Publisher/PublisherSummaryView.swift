/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class PublisherSummaryView: UIView {
  
  @objc public func setLocal(_ local: Bool) {
    if local {
      publisherView.publisherNameLabel.text = "Brave Browser";
      publisherView.faviconImageView.image = UIImage(frameworkResourceNamed: "local-icon")
      attentionView.valueLabel.text = "–";
    }
    publisherView.faviconImageView.contentMode = local ? .center : .scaleAspectFill
  }
  
  let scrollView = UIScrollView().then {
    $0.contentInsetAdjustmentBehavior = .never
    $0.delaysContentTouches = false
  }
  let stackView = UIStackView().then {
    $0.spacing = 8.0
    $0.axis = .vertical
  }
  @objc public let publisherView = PublisherView()
  @objc public let attentionView = PublisherAttentionView()
  @objc public let tipButton = ActionButton(type: .system).then {
    $0.tintColor = Colors.blurple400
    $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
    $0.setTitle(BATLocalizedString("BraveRewardsPublisherSendTip", "Send a tip").uppercased(), for: .normal)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    stackView.addArrangedSubview(publisherView)
    stackView.setCustomSpacing(20.0, after: publisherView)
    stackView.addArrangedSubview(attentionView)
    stackView.addArrangedSubview(SeparatorView())
    stackView.addArrangedSubview(SwitchRow().then {
      $0.textLabel.text = "Auto-Contribute"
    })
    stackView.addArrangedSubview(SeparatorView())
    stackView.setCustomSpacing(20.0, after: stackView.arrangedSubviews.last!)
    stackView.addArrangedSubview(tipButton)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    scrollView.contentLayoutGuide.snp.makeConstraints {
      $0.width.equalTo(self)
      $0.bottom.equalTo(stackView).offset(20.0)
    }
    stackView.snp.makeConstraints {
      $0.top.equalTo(self.scrollView.contentLayoutGuide.snp.top).offset(20.0)
      $0.leading.trailing.equalTo(self).inset(25.0)
    }
    tipButton.snp.makeConstraints {
      $0.height.equalTo(40.0)
    }
  }
}

extension PublisherSummaryView: WalletContentView {
  public var innerScrollView: UIScrollView? {
    return scrollView
  }
  public var displaysRewardsSummaryButton: Bool {
    return true
  }
}

