/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class WelcomeViewController: UIViewController {
  
  let state: RewardsState
  
  init(state: RewardsState) {
    self.state = state
    
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  var welcomeView: View {
    return view as! View // swiftlint:disable:this force_cast
  }
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    preferredContentSize = CGSize(width: RewardsUX.preferredPanelSize.width, height: 750)
    
    welcomeView.createWalletButtons.forEach {
      $0.addTarget(self, action: #selector(tappedCreateWallet(_:)), for: .touchUpInside)
    }
    
    welcomeView.termsOfServiceLabels.forEach({
      $0.onLinkedTapped = self.tappedDisclaimerLink
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // When this view disappears we want to remove it from the naviagation stack
    if let nc = navigationController, nc.viewControllers.first === self {
      nc.viewControllers = [UIViewController](nc.viewControllers.dropFirst())
    }
  }
  
  @objc private func tappedCreateWallet(_ sender: CreateWalletButton) {
    if sender.isCreatingWallet {
      return
    }
    sender.isCreatingWallet = true
    state.ledger.createWallet { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
        sender.isCreatingWallet = false
        return
      }
      self.state.ledger.fetchWalletDetails({ [weak self] _ in
        guard let self = self else { return }
        defer { sender.isCreatingWallet = false }
        self.show(WalletViewController(state: self.state), sender: self)
      })
    }
  }
  
  private func tappedDisclaimerLink(_ url: URL) {
    switch url.path {
    case "/terms":
      state.delegate?.loadNewTabWithURL(URL(string: "https://brave.com/terms-of-use/")!) //swiftlint:disable:this force_unwrapping
      
    case "/policy":
      state.delegate?.loadNewTabWithURL(URL(string: "https://brave.com/privacy/#rewards")!) //swiftlint:disable:this force_unwrapping
      
    default:
      break
    }
  }
}
