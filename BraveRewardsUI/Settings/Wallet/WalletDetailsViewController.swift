/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class WalletDetailsViewController: UIViewController, RewardsSummaryProtocol {

  let state: RewardsState
  
  init(state: RewardsState) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    view = View(isEmpty: state.ledger.balance == 0.0)
  }
  
  var detailsView: View {
    return view as! View
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = Strings.WalletDetailsTitle
    
    detailsView.walletSection.addFundsButton.addTarget(self, action: #selector(tappedAddFunds), for: .touchUpInside)
    
    detailsView.walletSection.setWalletBalance(
      state.ledger.balanceString,
      crypto: "BAT",
      dollarValue: state.ledger.usdBalanceString
    )
    
    detailsView.activityView.monthYearLabel.text = summaryPeriod
    detailsView.activityView.rows = summaryRows
    detailsView.activityView.disclaimerView = disclaimerView
  }
  
  // MARK: - Actions
  
  @objc private func tappedAddFunds() {
    let controller = AddFundsViewController(state: state)
    let container = PopoverNavigationController(rootViewController: controller)
    present(container, animated: true)
  }
}
