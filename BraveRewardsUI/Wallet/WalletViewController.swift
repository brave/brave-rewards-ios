/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public protocol WalletContentView {
  var scrollView: UIScrollView? { get }
  var displaysRewardsSummaryButton: Bool { get }
}

public class WalletViewController: UIViewController {
  
  public let headerView = WalletHeaderView().then {
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  public var contentView: (UIView & WalletContentView)?
  
//  let rewardsSummaryView = BAT
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
}
