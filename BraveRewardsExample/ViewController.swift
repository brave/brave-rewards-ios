/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class UIMockLedger: BraveLedger {
  let defaults = UserDefaults.standard
  
  static func reset() {
    UserDefaults.standard.removeObject(forKey: "BATUILedgerEnabled")
    UserDefaults.standard.removeObject(forKey: "BATUIWalletCreated")
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
  override func createWallet(_ completion: ((Error?) -> Void)? = nil) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.isWalletCreated = true
      completion?(nil)
    }
  }
}


extension BraveRewardsPanelController: PopoverContentComponent {
  
  var customArrowColor: UIColor? {
    return UIColor(red: 61.0/255.0, green: 45.0/255.0, blue: 206.0/255.0, alpha: 1.0)
  }
  var isPanToDismissEnabled: Bool {
    return self.visibleViewController === self.viewControllers.first
  }
}

class ViewController: UIViewController {
  
  var popover: PopoverController?
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!
  @IBOutlet var useMockLedgerSwitch: UISwitch!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    braveRewardsPanelButton.setImage(BraveRewardsPanelController.batLogoImage, for: .normal)
  }

  @IBAction func tappedBraveRewards() {
    if UIDevice.current.userInterfaceIdiom != .pad && UIApplication.shared.statusBarOrientation.isLandscape {
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    let ledger = useMockLedgerSwitch.isOn ? UIMockLedger() : BraveLedger()
    let url = URL(string: "https://github.com")!
    let braveRewardsPanel = BraveRewardsPanelController(
      ledger: ledger,
      url: url,
      faviconURL: URL(string: "https://github.com/apple-touch-icon.png")!,
      delegate: self,
      dataSource: self
    )
    popover = PopoverController(contentController: braveRewardsPanel, contentSizeBehavior: .preferredContentSize)
    popover?.addsConvenientDismissalMargins = false
    popover?.present(from: braveRewardsPanelButton, on: self)
  }
  
  @IBAction func tappedSettings() {
    let ledger = useMockLedgerSwitch.isOn ? UIMockLedger() : BraveLedger()
    let controller = BraveRewardsSettingsViewController(ledger: ledger)
    let container = UINavigationController(rootViewController: controller)
    present(container, animated: true)
  }
  
  @IBAction func tappedResetMockLedger() {
    UIMockLedger.reset()
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let ledgerStatePath = documents.appendingPathComponent("brave_ledger")
    try? FileManager.default.removeItem(atPath: ledgerStatePath)
  }
}

extension ViewController: BraveRewardsDelegate {
  func presentBraveRewardsController(_ viewController: UIViewController) {
    popover?.dismiss(animated: true) {
      self.present(viewController, animated: true)
    }
  }
}

extension ViewController: BraveRewardsDataSource {
  func displayString(for url: URL) -> String? {
    return url.host
  }
  
  func retrieveFavicon(with url: URL, completion completionBlock: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          completionBlock(image)
        }
        return
      }
      DispatchQueue.main.async {
        completionBlock(nil)
      }
    }
  }
}
