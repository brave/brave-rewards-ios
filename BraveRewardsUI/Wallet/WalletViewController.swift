/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

@objc public protocol WalletContentView: AnyObject {
  var innerScrollView: UIScrollView? { get }
  var displaysRewardsSummaryButton: Bool { get }
}

public class WalletViewController: UIViewController {
  
  @objc public let headerView = WalletHeaderView().then {
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  @objc public var contentView: (UIView & WalletContentView)? {
    willSet {
      contentView?.removeFromSuperview()
    }
    didSet {
      if (isViewLoaded) {
        setupContentView()
      }
    }
  }
  
  public let rewardsSummaryView = RewardsSummaryView()
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    rewardsSummaryView.rewardsSummaryButton.addTarget(self, action: #selector(tappedRewardsSummaryButton), for: .touchUpInside)
    
    // FIXME: Remove temp values
    rewardsSummaryView.monthYearLabel.text = "MARCH 2019"
    rewardsSummaryView.rows = [
      RowView(title: "Total Grants Claimed Total Grants Claimed", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Earnings from Ads", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Auto-Contribute", batValue: "-10.0", usdDollarValue: "-5.25"),
      RowView(title: "One-Time Tips", batValue: "-2.0", usdDollarValue: "-1.05"),
      RowView(title: "Monthly Tips", batValue: "-19.0", usdDollarValue: "-9.97"),
    ]
    
    setupContentView()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: -
  
  private var heightConstraint: Constraint?
  private var summaryLayoutGuide = UILayoutGuide()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addLayoutGuide(summaryLayoutGuide)
    view.addSubview(headerView)
    
    view.snp.makeConstraints {
      self.heightConstraint = $0.height.equalTo(0).priority(.low).constraint
    }
    headerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view)
    }
    summaryLayoutGuide.snp.makeConstraints {
      $0.top.equalTo(self.headerView.snp.bottom).offset(20.0)
      $0.leading.trailing.equalTo(self.view)
    }
    
    setupContentView()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    headerView.layoutIfNeeded()
    contentView?.layoutIfNeeded()
    
    if let contentView = contentView {
      if let scrollView = contentView.innerScrollView {
        scrollView.contentInset = UIEdgeInsets(top: headerView.bounds.height, left: 0, bottom: 0, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPoint(x: 0, y: -headerView.bounds.height) // Make sure it shows the top part of the view
        
        let height = headerView.bounds.height + scrollView.contentSize.height + rewardsSummaryView.rewardsSummaryButton.bounds.height
        heightConstraint?.update(offset: height)
      } else {
        let height = headerView.bounds.height + contentView.bounds.height + rewardsSummaryView.rewardsSummaryButton.bounds.height
        heightConstraint?.update(offset: height)
      }
    }
  }
  
  // MARK: -
  
  private func setupContentView() {
    guard let contentView = contentView else { return }
    
    view.insertSubview(contentView, belowSubview: headerView)
    
    contentView.snp.makeConstraints {
      if let _ = contentView.innerScrollView {
        $0.top.equalTo(self.view)
      } else {
        $0.top.equalTo(self.headerView.snp.bottom)
      }
      $0.leading.trailing.equalTo(self.view)
    }
    
    if contentView.displaysRewardsSummaryButton {
      view.insertSubview(rewardsSummaryView, belowSubview: headerView)
      contentView.snp.makeConstraints {
        $0.bottom.equalTo(self.rewardsSummaryView.snp.top)
      }
      rewardsSummaryView.snp.makeConstraints {
        $0.leading.trailing.equalTo(self.view)
        $0.height.equalTo(self.summaryLayoutGuide)
      }
      rewardsSummaryView.rewardsSummaryButton.snp.makeConstraints {
        $0.bottom.equalTo(self.view)
      }
    } else {
      rewardsSummaryView.removeFromSuperview()
      contentView.snp.makeConstraints {
        $0.bottom.equalTo(self.view)
      }
    }
    
    summaryLayoutGuide.snp.makeConstraints { $0.bottom.equalTo(self.view) }
  }
  
  @objc private func tappedRewardsSummaryButton() {
    let isExpanding = rewardsSummaryView.transform.ty == 0;
    rewardsSummaryView.rewardsSummaryButton.slideToggleImageView.image =
      UIImage(frameworkResourceNamed: isExpanding ? "slide-down" : "slide-up")
    
    // Animating the rewards summary with a bit of a bounce
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: [], animations: {
      if (isExpanding) {
        self.rewardsSummaryView.transform = CGAffineTransform(
          translationX: 0,
          y: -self.summaryLayoutGuide.layoutFrame.height + self.rewardsSummaryView.rewardsSummaryButton.bounds.height
        )
      } else {
        self.rewardsSummaryView.transform = .identity
      }
    }, completion: nil)
    
    if (isExpanding) {
      // Prepare animation
      rewardsSummaryView.monthYearLabel.isHidden = false
      rewardsSummaryView.monthYearLabel.alpha = 0.0
    }
    // But animate the rest without a bounce (since it doesnt make sense)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [], animations: {
      if (isExpanding) {
        self.contentView?.alpha = 0.0
        self.rewardsSummaryView.monthYearLabel.alpha = 1.0
        self.view.backgroundColor = Colors.blurple800
      } else {
        self.contentView?.alpha = 1.0
        self.rewardsSummaryView.monthYearLabel.alpha = 0.0
        self.view.backgroundColor = .white
      }
    }) { _ in
      self.rewardsSummaryView.monthYearLabel.isHidden = !(self.rewardsSummaryView.monthYearLabel.alpha > 0.0)
      self.rewardsSummaryView.alpha = 1.0
    }
  }
}
