/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class WalletDetailsViewController: UIViewController {

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
    // FIXME: Use ledger balance
    view = View(isEmpty: false /*ledger.balance == 0.0*/)
  }
  
  var detailsView: View {
    return view as! View
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = BATLocalizedString("BraveRewardsWalletDetailsTitle", "Wallet Details")
    
    detailsView.walletSection.addFundsButton.addTarget(self, action: #selector(tappedAddFunds), for: .touchUpInside)
    
    // FIXME: Remove temp values
    if let dollarString = state.ledger.dollarStringForBATAmount(30) {
      detailsView.walletSection.setWalletBalance("30", crypto: "BAT", dollarValue: dollarString)
    }
    detailsView.activityView.monthYearLabel.text = "March 2019"
    detailsView.activityView.rows = [
      RowView(title: "Total Grants Claimed", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Earnings from Ads", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Auto-Contribute", batValue: "-10.0", usdDollarValue: "-5.25"),
      RowView(title: "One-Time Tips", batValue: "-2.0", usdDollarValue: "-1.05"),
      RowView(title: "Monthly Tips", batValue: "-19.0", usdDollarValue: "-9.97"),
    ]
    // FIXME: Set this disclaimer based on contributions going to unverified publishers
    let disclaimerText = String(format: BATLocalizedString("BraveRewardsContributingToUnverifiedSites", "You've designated %d BAT for creators who haven't yet signed up to recieve contributions. Your browser will keep trying to contribute until they verify, or until 90 days have passed."), 52)
    detailsView.activityView.disclaimerView = DisclaimerView(text: disclaimerText)
  }
  
  // MARK: - Actions
  
  @objc private func tappedAddFunds() {
    let controller = AddFundsViewController(state: state)
    let container = PopoverNavigationController(rootViewController: controller)
    present(container, animated: true)
  }
}
