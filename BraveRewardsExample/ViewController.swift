/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

extension BraveRewardsPanelController: PopoverContentComponent {
  var customArrowColor: UIColor? {
    return UIColor(red: 61.0/255.0, green: 45.0/255.0, blue: 206.0/255.0, alpha: 1.0)
  }
  
  var pinToScreenHorizontalEdges: Bool {
    return true
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!
  @IBOutlet var tippingPanelButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    braveRewardsPanelButton.setImage(UIImage(named: "bat", in: Bundle(for: BraveRewardsPanelController.self), compatibleWith: nil), for: .normal)
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func tappedBraveRewards() {
    if UIDevice.current.userInterfaceIdiom != .pad && UIApplication.shared.statusBarOrientation.isLandscape {
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    let ledger = BraveLedger()
    let url = URL(string: "https://facebook.com")!
    let braveRewardsPanel = BraveRewardsPanelController(ledger: ledger, url: url, isLocal: false, favicon: nil)
    let popover = PopoverController(contentController: braveRewardsPanel, contentSizeBehavior: .autoLayout)
    popover.addsConvenientDismissalMargins = false
    popover.present(from: braveRewardsPanelButton, on: self)
  }
  
  @IBAction func tappedSettings() {
    
  }
  
  @IBAction func tappedTipping() {
    let tip = BraveRewardsTippingViewController()
    present(tip, animated: true)
  }
}

