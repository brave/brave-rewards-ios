/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class WalletActivityView: SettingsSectionView {
  
  private struct UX {
    static let monthYearColor = Colors.blurple400
  }
  
  let stackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  public let monthYearLabel = UILabel().then {
    $0.textColor = UX.monthYearColor
    $0.font = .systemFont(ofSize: 22.0, weight: .medium)
  }
  
  public var rows: [RowView] = [] {
    willSet {
      rows.forEach {
        $0.removeFromSuperview()
      }
    }
    didSet {
      rows.forEach {
        stackView.addArrangedSubview($0)
        if $0 !== rows.last {
          stackView.addArrangedSubview(SeparatorView())
        }
      }
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    // FIXME: Remove temp values
    defer {
      monthYearLabel.text = "March 2019"
      rows = [
        RowView(title: "Total Grants Claimed", batValue: "10.0", usdDollarValue: "5.25"),
        RowView(title: "Earnings from Ads", batValue: "10.0", usdDollarValue: "5.25"),
        RowView(title: "Auto-Contribute", batValue: "-10.0", usdDollarValue: "-5.25"),
        RowView(title: "One-Time Tips", batValue: "-2.0", usdDollarValue: "-1.05"),
        RowView(title: "Monthly Tips", batValue: "-19.0", usdDollarValue: "-9.97"),
      ]
    }
    
    addSubview(stackView)
    
    stackView.addArrangedSubview(monthYearLabel)
    stackView.setCustomSpacing(8.0, after: monthYearLabel)
    
    stackView.snp.makeConstraints {
      $0.edges.equalTo(layoutMarginsGuide)
    }
  }
}
