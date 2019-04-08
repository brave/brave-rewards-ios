/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class EmptyTipsTableCell: UITableViewCell, TableViewReusable {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let label = UILabel().then {
      $0.text = BATLocalizedString("BraveRewardsEmptyTipsText", "Have you tipped your favourite content creator today?")
      $0.textColor = SettingsUX.bodyTextColor
      $0.textAlignment = .center
      $0.font = SettingsUX.bodyFont
      $0.numberOfLines = 0
    }
    contentView.addSubview(label)
    label.snp.makeConstraints {
      $0.leading.trailing.equalTo(contentView).inset(45)
      $0.top.bottom.equalTo(contentView).inset(25)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}

