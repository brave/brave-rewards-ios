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
  
  var popover: PopoverController?
  
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var braveRewardsPanelButton: UIButton!
  @IBOutlet var tippingPanelButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    braveRewardsPanelButton.setImage(BraveRewardsPanelController.batLogoImage, for: .normal)
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func tappedBraveRewards() {
    if UIDevice.current.userInterfaceIdiom != .pad && UIApplication.shared.statusBarOrientation.isLandscape {
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    let ledger = BraveLedger()
    let url = URL(string: "https://github.com")!
    let braveRewardsPanel = BraveRewardsPanelController(
      ledger: ledger,
      url: url,
      faviconURL: URL(string: "https://github.com/apple-touch-icon.png")!,
      delegate: self,
      dataSource: self
    )
    popover = PopoverController(contentController: braveRewardsPanel, contentSizeBehavior: .autoLayout)
    popover?.addsConvenientDismissalMargins = false
    popover?.present(from: braveRewardsPanelButton, on: self)
  }
  
  @IBAction func tappedSettings() {
    
  }
  
  @IBAction func tappedTipping() {
    let tip = BraveRewardsTippingViewController(ledger: BraveLedger(), publisherId: "")
    present(tip, animated: true)
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
