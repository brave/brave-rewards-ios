/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class WalletDetailsView: UIView {
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = SettingsUX.backgroundColor
    
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    scrollView.contentLayoutGuide.snp.makeConstraints {
      $0.width.equalTo(self)
    }
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self.scrollView.contentLayoutGuide).inset(10.0)
    }
  }
  
  // MARK: - Private UI
  
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.delaysContentTouches = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10.0
  }
}
