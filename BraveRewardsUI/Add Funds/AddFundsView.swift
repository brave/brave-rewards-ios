/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

extension AddFundsViewController {
  class View: UIView {
    
    var tokenViews: [TokenAddressView] = [] {
      willSet {
        tokenViews.forEach { $0.removeFromSuperview() }
      }
      didSet {
        tokenViews.forEach { tokensStackView.addArrangedSubview($0) }
      }
    }
    
    let tokensStackView = UIStackView().then {
      $0.axis = .vertical
      $0.spacing = 30.0
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      backgroundColor = .white
      
      let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8.0
      }
      
      let titleLabel = UILabel().then {
        $0.textColor = SettingsUX.headerTextColor
        $0.font = .systemFont(ofSize: 22.0, weight: .medium)
        $0.text = BATLocalizedString("BraveRewardsAddFundsTitle", "Send cryptocurrency from your external account to your Brave Rewards wallet.")
        $0.numberOfLines = 0
      }
      
      let bodyLabel = UILabel().then {
        $0.textColor = SettingsUX.bodyTextColor
        $0.font = .systemFont(ofSize: 14.0)
        $0.text = BATLocalizedString("BraveRewardsAddFundsBody", "Be sure to use the address below that matches the type of crypto you own. It will be converted automatically to BAT by Uphold and appear as an increased balance in your Brave Rewards wallet. Please allow up to one hour for your wallet balance to update.")
        $0.numberOfLines = 0
      }
      
      let disclaimerLabel = UILabel().then {
        $0.textColor = SettingsUX.bodyTextColor
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12.0)
        $0.text = BATLocalizedString("BraveRewardsAddFundsDisclaimer", "Reminder: The Brave Wallet is unidirectional and BAT flows to publisher sites. For more information about Brave Rewards, please visit the FAQ.")
        $0.numberOfLines = 0
      }
      
      let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.delaysContentTouches = false
      }
      
      addSubview(scrollView)
      scrollView.addSubview(stackView)
      stackView.addStackViewItems(
        .view(titleLabel),
        .view(bodyLabel),
        .customSpace(30.0),
        .view(tokensStackView),
        .customSpace(30.0),
        .view(disclaimerLabel)
      )
      
      scrollView.snp.makeConstraints {
        $0.edges.equalTo(self)
      }
      scrollView.contentLayoutGuide.snp.makeConstraints {
        $0.width.equalTo(self)
      }
      stackView.snp.makeConstraints {
        $0.edges.equalTo(scrollView.contentLayoutGuide).inset(25)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}
