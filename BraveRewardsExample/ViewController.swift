/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards
import BraveRewardsUI

class UIMockLedger: BraveLedger {
  let defaults = UserDefaults.standard
  
  static func reset() {
    UserDefaults.standard.removeObject(forKey: "BATUILedgerEnabled")
    UserDefaults.standard.removeObject(forKey: "BATUIWalletCreated")
    UserDefaults.standard.removeObject(forKey: "BATUIAutoContributeEnabled")
  }
  override var balance: Double {
    return 30.0
  }
  override var isEnabled: Bool {
    get { return defaults.bool(forKey: "BATUILedgerEnabled") }
    set { return defaults.set(newValue, forKey: "BATUILedgerEnabled") }
  }
  override var isWalletCreated: Bool {
    get { return defaults.bool(forKey: "BATUIWalletCreated") }
    set { return defaults.set(newValue, forKey: "BATUIWalletCreated") }
  }
  override var isAutoContributeEnabled: Bool {
    get { return defaults.bool(forKey: "BATUIAutoContributeEnabled") }
    set { return defaults.set(newValue, forKey: "BATUIAutoContributeEnabled") }
  }
  override func createWallet(_ completion: ((Error?) -> Void)? = nil) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.isEnabled = true
      self.isWalletCreated = true
      self.isAutoContributeEnabled = true
      completion?(nil)
    }
  }
  
  override func balanceReport(for month: ActivityMonth, year: Int32) -> BalanceReportInfo {
    // Returns the same values for all months at the moment.
    // Could expand this to play with different values based on month or year.
    let info = BalanceReportInfo()
    info.earningFromAds = "12.5"
    info.autoContribute = "10.0"
    info.grants = "22.0"
    info.oneTimeDonation = "0"
    info.recurringDonation = "-20"
    
    return info
  }
  
  override var reservedAmount: Double { return 25.5 }
}


extension RewardsPanelController: PopoverContentComponent {
  var extendEdgeIntoArrow: Bool {
    return true
  }
  var isPanToDismissEnabled: Bool {
    return self.visibleViewController === self.viewControllers.first
  }
}

let stateStoragePath: String = (NSSearchPathForDirectoriesInDomains(
    .documentDirectory,
    .userDomainMask,
    true
  ).first! as NSString).appendingPathComponent("brave_ledger")

class ViewController: UIViewController {
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!
  @IBOutlet var useMockLedgerSwitch: UISwitch!
  
  var rewards: BraveRewards!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRewards()
    braveRewardsPanelButton.setImage(RewardsPanelController.batLogoImage, for: .normal)
  }
  
  func setupRewards() {
    if (useMockLedgerSwitch.isOn) {
      rewards = BraveRewards(configuration: .default, ledgerClass: UIMockLedger.self, adsClass: nil)
    } else {
      rewards = BraveRewards(configuration: .default)
    }
  }

  @IBAction func tappedBraveRewards() {
    if UIDevice.current.userInterfaceIdiom != .pad && UIApplication.shared.statusBarOrientation.isLandscape {
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
    
//    let ledger = useMockLedgerSwitch.isOn ? UIMockLedger() : self.ledger
    let url = URL(string: "https://bumpsmack.com")!
    let braveRewardsPanel = RewardsPanelController(
      rewards,
      url: url,
      faviconURL: URL(string: "https://github.com/apple-touch-icon.png")!,
      delegate: self,
      dataSource: self
    )
    let popover = PopoverController(contentController: braveRewardsPanel, contentSizeBehavior: .preferredContentSize)
    popover.addsConvenientDismissalMargins = false
    popover.present(from: braveRewardsPanelButton, on: self)
  }
  
  @IBAction func tappedResetMockLedger() {
    UIMockLedger.reset()
    rewards.reset()
  }
  
  @IBAction func useMockLedgerValueChanged() {
    setupRewards()
  }
}

extension ViewController: RewardsUIDelegate {
  func presentBraveRewardsController(_ viewController: UIViewController) {
    self.presentedViewController?.dismiss(animated: true) {
      self.present(viewController, animated: true)
    }
  }
  func loadNewTabWithURL(_ url: URL) {
    print("Create new tab with URL: \(url.absoluteString)")
  }
}

extension ViewController: RewardsDataSource {
  func displayString(for url: URL) -> String? {
    return url.host
  }
  
  func retrieveFavicon(with url: URL, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          completion(image)
        }
        return
      }
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
}
