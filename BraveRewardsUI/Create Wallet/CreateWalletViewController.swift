/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class CreateWalletViewController: UIViewController {
  
  let state: RewardsState
  
  var createWalletView: View {
    return super.view as! View
  }
  
  init(state: RewardsState) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    createWalletView.createWalletButton.addTarget(self, action: #selector(tappedCreateWallet), for: .touchUpInside)
    createWalletView.learnMoreButton.addTarget(self, action: #selector(tappedLearnMore), for: .touchUpInside)
    
    let size = CGSize(width: RewardsUX.preferredPanelSize.width, height: UIScreen.main.bounds.height)
    preferredContentSize = view.systemLayoutSizeFitting(
      size,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // When this view disappears we want to remove it from the naviagation stack
    if let nc = navigationController, nc.viewControllers.first === self {
      nc.viewControllers = [UIViewController](nc.viewControllers.dropFirst())
    }
  }
  
  // MARK: - Actions
  
  @objc private func tappedCreateWallet() {
    createWalletView.isCreatingWallet = true
    state.ledger.createWallet { [weak self] error in
      guard let self = self else { return }
      defer { self.createWalletView.isCreatingWallet = false }
      if let _ = error {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
      }
      self.state.ledger.isEnabled = true
      self.show(WalletViewController(state: self.state), sender: self)
    }
  }
  
  @objc private func tappedLearnMore() {
    
  }
}


