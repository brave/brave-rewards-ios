/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

/// `BraveRewardsTippingViewController`'s loaded view
public class TippingView: UIView {
  
  // MARK: -
  
  private struct UX {
    static let overlayBackgroundColor = UIColor(white: 0.0, alpha: 0.6)
  }
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UX.overlayBackgroundColor
  }
  
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.showsVerticalScrollIndicator = false
  }
  
  private let overviewView = TippingOverviewView()
  
  private let optionSelectionView = TippingSelectionView().then {
    // iPhone only... probably
    $0.layer.shadowRadius = 8.0
    $0.layer.shadowOffset = CGSize(width: 0, height: -2)
    $0.layer.shadowOpacity = 0.35
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(backgroundView)
    addSubview(scrollView)
    scrollView.addSubview(overviewView)
    addSubview(optionSelectionView)
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    optionSelectionView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self)
    }
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    scrollView.contentLayoutGuide.snp.makeConstraints {
      $0.width.equalTo(self)
    }
    overviewView.snp.makeConstraints {
      $0.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
      $0.leading.trailing.equalTo(self).inset(10.0)
      $0.bottom.equalTo(self.scrollView.contentLayoutGuide.snp.bottom).offset(-10.0)
    }
    
    // FIXME: Remove fake data
    optionSelectionView.setWalletBalance("30", crypto: "BAT")
    optionSelectionView.options = ["1", "5", "10"].map { TippingOption.batAmount($0, dollarValue: "0.00 USD") }
    optionSelectionView.selectedOptionIndex = 1
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    optionSelectionView.layoutIfNeeded()
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: optionSelectionView.bounds.height, right: 0)
  }
}

extension TippingView: BasicAnimationControllerDelegate {
  public func animatePresentation(context: UIViewControllerContextTransitioning) {
    context.containerView.addSubview(self)
    context.completeTransition(true)
  }
  public func animateDismissal(context: UIViewControllerContextTransitioning) {
    removeFromSuperview()
    context.completeTransition(true)
  }
}
