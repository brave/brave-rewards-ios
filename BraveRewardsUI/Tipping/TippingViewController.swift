/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class TippingViewController: UIViewController, UIViewControllerTransitioningDelegate {
  
  let state: RewardsState
  let publisherId: String
  
  init(state: RewardsState, publisherId: String) {
    self.state = state
    self.publisherId = publisherId
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overFullScreen
    transitioningDelegate = self
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  var tippingView: View {
    return view as! View // swiftlint:disable:this force_cast
  }
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Not actually visible, but good for accessibility
    title = Strings.TippingTitle
    
    tippingView.overviewView.dismissButton.addTarget(self, action: #selector(tappedDismissButton), for: .touchUpInside)
    tippingView.optionSelectionView.sendTipButton.addTarget(self, action: #selector(tappedSendTip), for: .touchUpInside)
    tippingView.optionSelectionView.optionChanged = { [unowned self] option in
      if let balanceTotal = self.state.ledger.balance?.total {
        let hasEnoughBalanceForTip = option.value.doubleValue < balanceTotal
        self.tippingView.optionSelectionView.setEnoughFundsAvailable(hasEnoughBalanceForTip)
      }
    }
    tippingView.gesturalDismissExecuted = { [weak self] in
      self?.dismiss(animated: true)
    }
    tippingView.overviewView.disclaimerView.onLinkedTapped = { [weak self] _ in
      let url = URL(string: "https://brave.com/faq-rewards/#unclaimed-funds")!
      self?.state.delegate?.loadNewTabWithURL(url)
    }
    
    // FIXME: Set this disclaimer hidden based on whether or not the publisher is verified
    tippingView.overviewView.disclaimerView.isHidden = true
    
    tippingView.optionSelectionView.setWalletBalance(state.ledger.balanceString, crypto: "BAT")
    // FIXME: Remove fake data
    tippingView.optionSelectionView.options = [1.0, 5.0, 10.0].map {
      TippingOption.batAmount(BATValue($0), dollarValue: state.ledger.dollarStringForBATAmount($0) ?? "")
    }
  }
  
  // MARK: - Actions
  
  @objc private func tappedDismissButton() {
    dismiss(animated: true)
  }
  
  @objc private func tappedSendTip() {
    tippingView.setTippingConfirmationVisible(true, animated: true)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
      self?.dismiss(animated: true)
    }
  }
  
  // MARK: -
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .portrait
    }
    return .all
  }
  
  // MARK: - UIViewControllerTransitioningDelegate
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BasicAnimationController(delegate: tippingView, direction: .presenting)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BasicAnimationController(delegate: tippingView, direction: .dismissing)
  }
}
