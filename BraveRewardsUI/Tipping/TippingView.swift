/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

/// `BraveRewardsTippingViewController`'s loaded view
public class TippingView: UIView {
  
  @objc public var gesturalDismissExecuted: (() -> Void)?
  
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
  }
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UX.overlayBackgroundColor
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
    addSubview(overviewView)
    addSubview(optionSelectionView)
    
    overviewView.scrollView.delegate = self
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    optionSelectionView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self)
    }
    overviewView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(88.0)
      $0.leading.trailing.equalTo(self)
      $0.bottom.equalTo(self.optionSelectionView.snp.top)
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
  
  private var isPassedDismissalThreshold = false
  private var isDismissingByGesture = false
}

extension TippingView: BasicAnimationControllerDelegate {
  public func animatePresentation(context: UIViewControllerContextTransitioning) {
    context.containerView.addSubview(self)
    
    // Prepare
    layoutIfNeeded()
    backgroundView.alpha = 0.0
    overviewView.transform = CGAffineTransform(translationX: 0, y: bounds.height)
    optionSelectionView.transform = CGAffineTransform(translationX: 0, y: optionSelectionView.bounds.height)
    
    // Animate
    UIView.animate(withDuration: 0.15) {
      self.backgroundView.alpha = 1.0
    }
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [], animations: {
      self.overviewView.transform = .identity
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
      self.overviewView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
      self.optionSelectionView.transform = CGAffineTransform(translationX: 0, y: self.optionSelectionView.bounds.height)
    }) { _ in
      self.removeFromSuperview()
      context.completeTransition(true)
    }
    setTippingConfirmationVisible(false, animated: true)
  }
}

extension TippingView: UIScrollViewDelegate {
  
  private var dismissalThreshold: CGFloat {
    return -85.0
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Don't adjust transform once its going to dismiss (dismiss animation will handle that)
    if isDismissingByGesture { return }
    
    let offset = -min(0, scrollView.contentOffset.y + scrollView.contentInset.top)
    overviewView.transform = CGAffineTransform(translationX: 0, y: offset)
    // Offset change in overview transform with negative transform on the scroll view itself
    overviewView.scrollView.transform = CGAffineTransform(translationX: 0, y: -offset)
    
    // Deceleration cannot trigger the dismissal, so we shouldn't update the dismiss button even if it does decelerate
    // temporarly passed the threshold (from a hard flick, for instance)
    if scrollView.isDecelerating { return }
    
    if scrollView.contentOffset.y + scrollView.contentInset.top < dismissalThreshold {
      if !isPassedDismissalThreshold {
        isPassedDismissalThreshold = true
        overviewView.dismissButton.isHighlighted = true
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
          self.overviewView.dismissButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
          UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
            self.overviewView.dismissButton.transform = .identity
          }, completion: nil)
        })
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.prepare()
        feedback.impactOccurred()
      }
    } else {
      if isPassedDismissalThreshold {
        isPassedDismissalThreshold = false
        overviewView.dismissButton.isHighlighted = false
      }
    }
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y + scrollView.contentInset.top < dismissalThreshold {
      isDismissingByGesture = true
      self.gesturalDismissExecuted?()
    }
  }
}
