/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

//extension RewardsSummaryView {

  public class RowView: UIView {
    private struct UX {
      static let titleColor = Colors.grey000
      static let cryptoCurrencyColor = Colors.grey200
      static let dollarValueColor = Colors.grey200
    }
    
    let titleLabel = UILabel().then {
      $0.textColor = UX.titleColor
      $0.font = .systemFont(ofSize: 15.0)
      $0.numberOfLines = 0
      $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let cryptoValueLabel = UILabel().then {
      $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
    }
    
    let cryptoCurrencyLabel = UILabel().then {
      $0.textColor = UX.cryptoCurrencyColor
      $0.font = .systemFont(ofSize: 12.0)
    }
    
    let dollarValueLabel = UILabel().then {
      $0.textColor = UX.dollarValueColor
      $0.font = .systemFont(ofSize: 10.0)
      $0.textAlignment = .right
      $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    public override init(frame: CGRect) {
      super.init(frame: frame)
      
      let paddingGuide = UILayoutGuide()
      addLayoutGuide(paddingGuide)
      
      addSubview(titleLabel)
      addSubview(cryptoValueLabel)
      addSubview(cryptoCurrencyLabel)
      addSubview(dollarValueLabel)
      
      paddingGuide.snp.makeConstraints {
        $0.top.bottom.equalTo(self).inset(12.0)
        $0.leading.trailing.equalTo(self)
      }
      titleLabel.snp.makeConstraints {
        $0.top.leading.bottom.equalTo(paddingGuide)
        $0.trailing.lessThanOrEqualTo(self.cryptoValueLabel.snp.leading).offset(-12.0)
      }
      cryptoValueLabel.snp.makeConstraints {
        $0.firstBaseline.equalTo(self.titleLabel)
        $0.trailing.equalTo(self.cryptoCurrencyLabel.snp.leading).offset(-4.0)
      }
      cryptoCurrencyLabel.snp.makeConstraints {
        $0.firstBaseline.equalTo(self.cryptoValueLabel)
        $0.trailing.equalTo(self.dollarValueLabel.snp.leading).offset(-8.0)
      }
      dollarValueLabel.snp.makeConstraints {
        $0.firstBaseline.equalTo(self.cryptoValueLabel)
        $0.trailing.equalTo(paddingGuide)
        $0.width.greaterThanOrEqualTo(60.0)
      }
    }
    
    public convenience init(title: String, batValue: String, usdDollarValue: String) {
      self.init(frame: .zero)
      titleLabel.text = title
      cryptoCurrencyLabel.text = "BAT"
      cryptoValueLabel.text = batValue
      dollarValueLabel.text = "\(usdDollarValue) USD"
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
//}
