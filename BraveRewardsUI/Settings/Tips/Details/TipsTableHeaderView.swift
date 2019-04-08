/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

class TipsTableHeaderView: UIView {
  
  let siteColumnLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSite", "Site").uppercased()
    $0.textColor = Colors.blurple500
    $0.font = .systemFont(ofSize: 13.0)
  }
  let tokensColumnLabel = UILabel().then {
    $0.text = BATLocalizedString("BraveRewardsSite", "Tokens").uppercased()
    $0.textColor = Colors.blurple500
    $0.font = .systemFont(ofSize: 13.0)
    $0.textAlignment = .right
  }
  
  private let separatorView = SeparatorView().then {
    $0.backgroundColor = Colors.blurple500
  }
  
  private var siteWidthConstraint: Constraint?
  private var tokenWidthConstraint: Constraint?
  
  var columnWidthPercents: (Float, Float) = (0.7, 0.3) {
    didSet {
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    
    addSubview(siteColumnLabel)
    addSubview(tokensColumnLabel)
    addSubview(separatorView)
    
    siteColumnLabel.snp.makeConstraints {
      self.siteWidthConstraint = $0.width.equalTo(layoutMarginsGuide).multipliedBy(columnWidthPercents.0).constraint
      $0.leading.top.equalTo(layoutMarginsGuide)
    }
    tokensColumnLabel.snp.makeConstraints {
      $0.leading.equalTo(siteColumnLabel.snp.trailing)
      $0.trailing.top.equalTo(layoutMarginsGuide)
      self.tokenWidthConstraint = $0.width.equalTo(layoutMarginsGuide).multipliedBy(columnWidthPercents.1).constraint
    }
    separatorView.snp.makeConstraints {
      $0.top.equalTo(siteColumnLabel.snp.bottom).offset(4.0)
      $0.leading.trailing.bottom.equalTo(layoutMarginsGuide)
    }
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}
