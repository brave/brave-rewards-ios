/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards
import BraveRewardsUI

class UIMockLedger: BraveLedger {
  let defaults = UserDefaults.standard
  
  static var isUsingMockLedger: Bool {
    get { return UserDefaults.standard.bool(forKey: "BATIsUsingMockLedger") }
    set { UserDefaults.standard.set(newValue, forKey: "BATIsUsingMockLedger") }
  }
  
  static func reset() {
    UserDefaults.standard.removeObject(forKey: "BATUILedgerEnabled")
    UserDefaults.standard.removeObject(forKey: "BATUIWalletCreated")
    UserDefaults.standard.removeObject(forKey: "BATUIAutoContributeEnabled")
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
  
  override var balance: Balance? {
    return Balance().then {
      $0.total = 30.0
      $0.rates = ["USD": 0.3]
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

func rewardsLog(logLevel: LogLevel, line: Int32, file: String, data: String) {
  if !data.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
    // Should probably just trim the final trailing newline instead, since `print` only appends
    // a single newline terminator
    print("[\(logLevel.logPrefix)] \(data.trimmingCharacters(in: .newlines))")
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!
  @IBOutlet var useMockLedgerSwitch: UISwitch!
  
  var rewards: BraveRewards!
  
  private static let testPublisherURL = "https://3zsistemi.si" //"https://bumpsmack.com"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    RewardsLogger.configure(logCallback: rewardsLog, withFlush: nil)
    
    useMockLedgerSwitch.isOn = UIMockLedger.isUsingMockLedger
    
    setupRewards()
    braveRewardsPanelButton.setImage(RewardsPanelController.batLogoImage, for: .normal)
  }
  
  func setupRewards() {
    if (useMockLedgerSwitch.isOn) {
      rewards = BraveRewards(configuration: .default, delegate: self, ledgerClass: UIMockLedger.self, adsClass: nil)
      // Simulate visiting a sample url to test publisher verification.
      let url = URL(string: ViewController.testPublisherURL)!
      rewards.ledger.publisherActivity(from: url, faviconURL: url, publisherBlob: "")
    } else {
      rewards = BraveRewards(configuration: .default, delegate: self)
    }
  }

  @IBAction func tappedBraveRewards() {
    if UIDevice.current.userInterfaceIdiom != .pad && UIApplication.shared.statusBarOrientation.isLandscape {
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
    
//    let ledger = useMockLedgerSwitch.isOn ? UIMockLedger() : self.ledger
    let url = URL(string: ViewController.testPublisherURL)!
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
  
  @IBAction func tappedLoadContent(_ sender: Any) {
    DataLoader.loadContent(rewards: rewards)
  }
    
  @IBAction func tappedResetMockLedger() {
    UIMockLedger.reset()
    rewards.reset()
  }
  
  @IBAction func useMockLedgerValueChanged() {
    UIMockLedger.isUsingMockLedger = useMockLedgerSwitch.isOn
    setupRewards()
  }
}

extension ViewController: BraveRewardsDelegate {
  func faviconURL(fromPageURL pageURL: URL, completion: @escaping (URL?) -> Void) {
    guard let url = URL(string: "\(pageURL.scheme!)\(pageURL.host!)/favicon.ico") else {
      completion(nil)
      return
    }
    completion(url)
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
  
  func retrieveFavicon(for pageURL: URL, faviconURL: URL?, completion: @escaping (FaviconData?) -> Void) {
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: faviconURL ?? pageURL), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          completion(FaviconData(image: image, backgroundColor: .white))
        }
        return
      }
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
}
