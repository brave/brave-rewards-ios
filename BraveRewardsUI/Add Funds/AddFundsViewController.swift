/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class AddFundsViewController: UIViewController {
  
  var addFundsView: View {
    return view as! View
  }
  
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
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
    
    let map: [(TokenAddressView.TokenKind, String?)] = [
      (.bitcoin, ledger.btcAddress),
      (.ethereum, ledger.ethAddress),
      (.basicAttentionToken, ledger.batAddress),
      (.litecoin, ledger.ltcAddress)
    ]
    addFundsView.tokenViews = map.map { (kind, address) in
      TokenAddressView(tokenKind: kind).then {
        $0.addressTextView.text = address
        $0.viewQRCodeButtonTapped = { [weak self] addressView in
          self?.tappedViewTokenQRCode(addressView)
        }
      }
    }
  }
  
  // MARK: - Actions
  
  private func tappedViewTokenQRCode(_ addressView: TokenAddressView) {
    addFundsView.tokenViews.forEach {
      if $0 !== addressView {
        $0.setQRCode(image: nil)
      }
    }
    let map: [TokenAddressView.TokenKind: String] = [
      .bitcoin: ledger.btcAddress,
      .ethereum: ledger.ethAddress,
      .basicAttentionToken: ledger.batAddress,
      .litecoin: ledger.ltcAddress
    ].compactMapValues({ $0 })
    guard let address = map[addressView.tokenKind] else { return }
    let qrCode = "\(addressView.tokenKind.codePrefix):\(address)"
    addressView.setQRCode(image: QRCode.image(for: qrCode, size: CGSize(width: 90, height: 90)))
  }
  
  @objc private func tappedDone() {
    dismiss(animated: true)
  }
}
