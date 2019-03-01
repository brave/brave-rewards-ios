/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

/// `BraveRewardsTippingViewController`'s loaded view
public class TippingView: UIView {
  
  @objc public let dismissButton = UIButton(type: .system).then {
    $0.setImage(UIImage(frameworkResourceNamed: "close-icon"), for: .normal)
    $0.tintColor = .white
    $0.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    $0.layer.cornerRadius = UX.dismissButtonSize.width / 2.0
    $0.clipsToBounds = true
  }
  
  @objc public func setTippingConfirmationVisible(_ visible: Bool, animated: Bool = true) {
    if confirmationView.isHidden == !visible {
      // nothing to do
      return
    }
    
    if visible {
      addSubview(confirmationView)
      confirmationView.isHidden = false
      confirmationView.faviconImageView.image = overviewView.faviconImageView.image
      confirmationView.snp.makeConstraints {
        $0.edges.equalTo(self)
      }
      if animated {
        confirmationView.stackView.transform = CGAffineTransform(translationX: 0, y: bounds.height)
        confirmationView.backgroundColor = TippingConfirmationView.UX.backgroundColor.withAlphaComponent(0.0)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
          self.confirmationView.backgroundColor = TippingConfirmationView.UX.backgroundColor
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
          self.confirmationView.stackView.transform = .identity
        }, completion: nil)
      }
    } else {
      if animated {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
          self.confirmationView.backgroundColor = TippingConfirmationView.UX.backgroundColor.withAlphaComponent(0.0)
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
          self.confirmationView.stackView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: { _ in
          self.confirmationView.isHidden = true
          self.confirmationView.removeFromSuperview()
        })
      } else {
        self.confirmationView.isHidden = true
        self.confirmationView.removeFromSuperview()
      }
    }
  }
  
  // MARK: -
  
  private struct UX {
    static let overlayBackgroundColor = UIColor(white: 0.0, alpha: 0.7)
    static let dismissButtonSize = CGSize(width: 35.0, height: 35.0)
  }
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UX.overlayBackgroundColor
  }
  
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.showsVerticalScrollIndicator = false
  }
  
  private let confirmationView = TippingConfirmationView().then {
    $0.isHidden = true
  }
  
  @objc public let overviewView = TippingOverviewView()
  
  @objc public let optionSelectionView = TippingSelectionView().then {
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
    addSubview(dismissButton)
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    dismissButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(5.0)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15.0)
      $0.size.equalTo(UX.dismissButtonSize)
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
    
    // Prepare
    layoutIfNeeded()
    backgroundView.alpha = 0.0
    dismissButton.alpha = 0.0
    dismissButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    scrollView.transform = CGAffineTransform(translationX: 0, y: bounds.height)
    optionSelectionView.transform = CGAffineTransform(translationX: 0, y: optionSelectionView.bounds.height)
    
    // Animate
    UIView.animate(withDuration: 0.15) {
      self.backgroundView.alpha = 1.0
    }
    UIView.animate(withDuration: 0.4, delay: 0.25, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
      self.dismissButton.transform = .identity
      self.dismissButton.alpha = 1.0
    }, completion: nil)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [], animations: {
      self.scrollView.transform = .identity
      self.optionSelectionView.transform = .identity
    }, completion: nil)
    context.completeTransition(true)
  }
  public func animateDismissal(context: UIViewControllerContextTransitioning) {
    // Animate
    UIView.animate(withDuration: 0.15) {
      self.backgroundView.alpha = 0.0
    }
    UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
      self.dismissButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      self.dismissButton.alpha = 0.0
      self.scrollView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
      self.optionSelectionView.transform = CGAffineTransform(translationX: 0, y: self.optionSelectionView.bounds.height)
    }) { _ in
      self.removeFromSuperview()
      context.completeTransition(true)
    }
    setTippingConfirmationVisible(false, animated: true)
  }
}
