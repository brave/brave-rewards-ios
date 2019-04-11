/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

/// A view which pairs a BAT amount and USD amount
class BATUSDPairView: UIView {
  private let stackView = UIStackView()
  /// The BAT amount container
  let batContainer: CurrencyContainerView
  /// The USD amount container
  let usdContainer: CurrencyContainerView
  /// Whether or not to display them side-by-side horizontally (i.e. "0 BAT 0 USD") or centered
  /// vertically (i.e. "0 BAT \n 0 USD")
  var axis: NSLayoutConstraint.Axis = .horizontal {
    didSet {
      stackView.axis = axis
      switch axis {
      case .horizontal:
        stackView.alignment = .bottom
      case .vertical:
        stackView.alignment = .center
      }
    }
  }
  
  init(batAmountConfig: (UILabel) -> Void,
       batKindConfig: (UILabel) -> Void,
       usdConfig: (UILabel) -> Void) {
    self.batContainer = CurrencyContainerView(amountLabelConfig: batAmountConfig,
                                              kindLabelConfig: batKindConfig)
    self.usdContainer = CurrencyContainerView(uniformLabelConfig: usdConfig)
  
    super.init(frame: .zero)
    
    addSubview(stackView)
    stackView.addArrangedSubview(batContainer)
    stackView.addArrangedSubview(usdContainer)
    
    stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    
    // Defaults
    stackView.spacing = 5.0
    stackView.alignment = .bottom
    
    batContainer.kindLabel.text = "BAT"
    batContainer.amountLabel.text = "0"
    usdContainer.kindLabel.text = "USD"
    usdContainer.amountLabel.text = "0.00"
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}
