/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

public class RewardsPanelController: PopoverNavigationController {
  
  public static let batLogoImage = UIImage(frameworkResourceNamed: "bat-small")
  
  public init(ledger: BraveLedger, url: URL, faviconURL: URL?, delegate: RewardsUIDelegate, dataSource: RewardsDataSource) {
    super.init()
    
    let state = RewardsState(ledger: ledger, url: url, faviconURL: faviconURL, delegate: delegate, dataSource: dataSource)
    
    if !ledger.isWalletCreated {
      viewControllers = [CreateWalletViewController(state: state)]
    } else {
      viewControllers = [WalletViewController(state: state)]
    }
  }
}
