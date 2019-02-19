/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

extension BraveRewardsPanelController: PopoverContentComponent {
  var pinToScreenHorizontalEdges: Bool {
    return true
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func tappedBraveRewards() {
    let ledger = BraveLedger()
    let url = URL(string: "https://facebook.com")!
    let braveRewardsPanel = BraveRewardsPanelController(ledger: ledger, url: url, isLocal: false, favicon: nil)
    let popover = PopoverController(contentController: braveRewardsPanel, contentSizeBehavior: .autoLayout)
    popover.addsConvenientDismissalMargins = false
    popover.present(from: braveRewardsPanelButton, on: self)
  }
  
  @IBAction func tappedSettings() {
    
  }
}

