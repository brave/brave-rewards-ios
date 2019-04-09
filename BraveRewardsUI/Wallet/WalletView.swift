/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

extension WalletViewController {
  
  class View: UIView {
    
    let headerView = WalletHeaderView()
    
    var contentView: (UIView & WalletContentView)? {
      willSet {
        if newValue === contentView { return }
        contentView?.removeFromSuperview()
      }
      didSet {
        if oldValue === contentView { return }
        setupContentView()
      }
    }
    
    let rewardsSummaryView = RewardsSummaryView()
    let summaryLayoutGuide = UILayoutGuide()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      
      backgroundColor = .white
      clipsToBounds = true
      
      addLayoutGuide(summaryLayoutGuide)
      addSubview(headerView)
      
      headerView.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self)
      }
      summaryLayoutGuide.snp.makeConstraints {
        $0.top.equalTo(self.headerView.snp.bottom).offset(20.0)
        $0.leading.trailing.equalTo(self)
      }
      
      setupContentView()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
    
    
    // MARK: -
    
    private func setupContentView() {
      guard let contentView = contentView else { return }
      
      insertSubview(contentView, belowSubview: headerView)
      
      contentView.snp.makeConstraints {
        if let _ = contentView.innerScrollView {
          $0.top.equalTo(self)
        } else {
          $0.top.equalTo(self.headerView.snp.bottom)
        }
        $0.leading.trailing.equalTo(self)
      }
      
      if contentView.displaysRewardsSummaryButton {
        insertSubview(rewardsSummaryView, belowSubview: headerView)
        contentView.snp.makeConstraints {
          $0.bottom.equalTo(self.rewardsSummaryView.snp.top)
        }
        rewardsSummaryView.snp.makeConstraints {
          $0.leading.trailing.equalTo(self)
          $0.height.equalTo(self.summaryLayoutGuide)
        }
        rewardsSummaryView.rewardsSummaryButton.snp.makeConstraints {
          $0.bottom.equalTo(self)
        }
      } else {
        rewardsSummaryView.removeFromSuperview()
        contentView.snp.makeConstraints {
          $0.bottom.equalTo(self)
        }
      }
      
      summaryLayoutGuide.snp.makeConstraints { $0.bottom.equalTo(self) }
    }
  }
}
