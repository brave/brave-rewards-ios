/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class AutoContributeSummaryTableCell: UITableViewCell, TableViewReusable {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    preservesSuperviewLayoutMargins = false
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    UIColor(white: 0.8, alpha: 1.0).setFill()
    let height = 1.0 / UIScreen.main.scale
    UIRectFill(CGRect(x: 0, y: rect.maxY - height, width: rect.width, height: height))
  }
}
