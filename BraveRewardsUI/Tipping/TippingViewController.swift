/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

enum PublisherMediaType: String {
  case youtube
  case twitter
  case twitch
  
  var iconName: String {
    switch self {
    case .youtube:
      return "pub-youtube"
      
    case .twitter:
      return "pub-twitter"
      
    case .twitch:
      return "pub-twitch"
    }
  }
}

class TippingViewController: UIViewController, UIViewControllerTransitioningDelegate {
  
  let state: RewardsState
  let publisherInfo: PublisherInfo
  private static let defaultTippingAmounts = [1.0, 5.0, 10.0]
  
  init(state: RewardsState, publisherInfo: PublisherInfo) {
    self.state = state
    self.publisherInfo = publisherInfo
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overFullScreen
    transitioningDelegate = self
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  var tippingView: View {
    return view as! View // swiftlint:disable:this force_cast
  }
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Not actually visible, but good for accessibility
    title = Strings.TippingTitle
    
    tippingView.overviewView.dismissButton.addTarget(self, action: #selector(tappedDismissButton), for: .touchUpInside)
    tippingView.optionSelectionView.sendTipButton.addTarget(self, action: #selector(tappedSendTip), for: .touchUpInside)
    tippingView.optionSelectionView.optionChanged = { [weak self] option in
      guard let self = self else { return }
      if let balanceTotal = self.state.ledger.balance?.total {
        let hasEnoughBalanceForTip = option.value.doubleValue < balanceTotal
        self.tippingView.optionSelectionView.setEnoughFundsAvailable(hasEnoughBalanceForTip)
      } else {
        self.tippingView.optionSelectionView.setEnoughFundsAvailable(false)
      }
    }
    tippingView.gesturalDismissExecuted = { [weak self] in
      self?.dismiss(animated: true)
    }
    tippingView.overviewView.disclaimerView.onLinkedTapped = { [weak self] _ in
      let url = URL(string: "https://brave.com/faq-rewards/#unclaimed-funds")!
      self?.state.delegate?.loadNewTabWithURL(url)
    }
    
    // FIXME: Set this disclaimer hidden based on whether or not the publisher is verified
    tippingView.overviewView.disclaimerView.isHidden = true
    
    tippingView.optionSelectionView.setWalletBalance(state.ledger.balanceString, crypto: "BAT")
    // FIXME: Remove fake data
    tippingView.optionSelectionView.options = TippingViewController.defaultTippingAmounts.map {
      TippingOption.batAmount(BATValue($0), dollarValue: state.ledger.dollarStringForBATAmount($0) ?? "")
    }
    
    loadPublisherBanner()
  }
  
  // MARK: - Networking
  private func loadPublisherBanner() {
    state.ledger.publisherBanner(forId: self.publisherInfo.id) { [weak self] banner in
      guard let self = self, let banner = banner else { return }
      
      self.tippingView.overviewView.titleLabel.text = banner.title.isEmpty ? Strings.TippingOverviewTitle : banner.title
      self.tippingView.overviewView.bodyLabel.text = banner.desc.isEmpty ? Strings.TippingOverviewBody : banner.desc
      
      self.downloadImage(url: banner.background, { image in
        self.tippingView.overviewView.headerView.image = image
      })
      
      if let dataSource = self.state.dataSource, let favIconURL = self.state.faviconURL {
        dataSource.retrieveFavicon(with: favIconURL, completion: { favIconData in
          self.tippingView.overviewView.faviconImageView.image = favIconData?.image
        })
      }
      
      self.tippingView.overviewView.socialStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
      
      if !banner.social.isEmpty {
        let orderedIcons: [PublisherMediaType] = [.youtube, .twitter, .twitch]
        let medias = banner.social.keys.compactMap({ PublisherMediaType(rawValue: $0) })
        
        orderedIcons.filter(medias.contains).forEach({
          self.tippingView.overviewView.socialStackView.addArrangedSubview(UIImageView(image: UIImage(frameworkResourceNamed: $0.iconName)))
        })
      }
      
      self.tippingView.overviewView.disclaimerView.isHidden = banner.verified
      
      let bannerAmounts = banner.amounts.isEmpty ? TippingViewController.defaultTippingAmounts : banner.amounts.compactMap({ $0.doubleValue })
      self.tippingView.optionSelectionView.options = bannerAmounts.map {
        TippingOption.batAmount(BATValue($0), dollarValue: self.state.ledger.dollarStringForBATAmount($0) ?? "")
      }
    }
  }
  
  private func downloadImage(url: String, _ completion: @escaping (UIImage?) -> Void) {
    guard !url.isEmpty, let url = URL(string: url.replacingOccurrences(of: "chrome://rewards-image/", with: "")) else {
      completion(nil)
      return
    }
    
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          completion(image)
        }
        return
      }
      
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
  
  // MARK: - Actions
  
  @objc private func tappedDismissButton() {
    dismiss(animated: true)
  }
  
  @objc private func tappedSendTip() {
    if let selectedIndex = self.tippingView.optionSelectionView.selectedOptionIndex {
      let amount = self.tippingView.optionSelectionView.options[selectedIndex].value.doubleValue
      
      state.ledger.listRecurringTips { [weak self] info in
        guard let self = self else { return }
        
        // If the user has recurring tips, remove the monthly tip
        if info.firstIndex(where: { $0.id == self.publisherInfo.id }) != nil {
          self.state.ledger.removeRecurringTip(publisherId: self.publisherInfo.id)
        }
        
        // Add recurring tips if there is none..
        if self.tippingView.optionSelectionView.isMonthly {
          self.state.ledger.addRecurringTip(publisherId: self.publisherInfo.id, amount: amount)
        }
        
        // TODO: Figure out -- Not sure why amount is of type integer..
        // Also not sure user's currency
        self.state.ledger.tipPublisherDirectly(self.publisherInfo, amount: Int32(amount), currency: "BAT")
        
        self.tippingView.setInfo(name: self.publisherInfo.name, tipAmount: amount)
        self.tippingView.setTippingConfirmationVisible(true, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
          self?.dismiss(animated: true)
        }
      }
    }
  }
  
  // MARK: -
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .portrait
    }
    return .all
  }
  
  // MARK: - UIViewControllerTransitioningDelegate
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BasicAnimationController(delegate: tippingView, direction: .presenting)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BasicAnimationController(delegate: tippingView, direction: .dismissing)
  }
}
