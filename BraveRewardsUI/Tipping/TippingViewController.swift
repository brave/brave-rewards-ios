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
    return view as! View
  }
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Not actually visible, but good for accessibility
    title = BATLocalizedString("BraveRewardsTippingTitle", "Send a tip")
    
    tippingView.overviewView.dismissButton.addTarget(self, action: #selector(tappedDismissButton), for: .touchUpInside)
    tippingView.optionSelectionView.sendTipButton.addTarget(self, action: #selector(tappedSendTip), for: .touchUpInside)
    tippingView.optionSelectionView.optionChanged = { [unowned self] option in
      guard let intValue = Int(option.value) else { return }
      // FIXME: Switch funds available UI based on real data
      self.tippingView.optionSelectionView.setEnoughFundsAvailable(intValue < 10)
    }
    tippingView.gesturalDismissExecuted = { [weak self] in
      self?.dismiss(animated: true)
    };
    tippingView.overviewView.disclaimerView.learnMoreTapped = { [weak self] in
      let url = URL(string: "https://brave.com/faq-rewards/#unclaimed-funds")!
      self?.state.delegate?.loadNewTabWithURL(url)
    };
    
    // FIXME: Set this disclaimer hidden based on whether or not the publisher is verified
    tippingView.overviewView.disclaimerView.isHidden = true
    
    // FIXME: Remove fake data
    tippingView.optionSelectionView.setWalletBalance("30", crypto: "BAT")
    tippingView.optionSelectionView.options = [1.0, 5.0, 10.0].map {
      TippingOption.batAmount("\($0)", dollarValue: state.ledger.dollarStringForBATAmount($0) ?? "")
    }
    tippingView.optionSelectionView.selectedOptionIndex = 1
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
