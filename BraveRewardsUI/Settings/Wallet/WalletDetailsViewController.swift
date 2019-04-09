/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class WalletDetailsViewController: UIViewController {

  let ledger: BraveLedger
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    view = View()
  }
  
  var detailsView: View {
    return view as! View
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    detailsView.walletSection.addFundsButton.addTarget(self, action: #selector(tappedAddFunds), for: .touchUpInside)
  }
  
  // MARK: - Actions
  
  @objc private func tappedAddFunds() {
    let controller = AddFundsViewController(ledger: ledger)
    let container = PopoverNavigationController(rootViewController: controller)
    present(container, animated: true)
  }
}
