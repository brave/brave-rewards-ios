/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

protocol WalletContentView: AnyObject {
  var innerScrollView: UIScrollView? { get }
  var displaysRewardsSummaryButton: Bool { get }
}

class WalletViewController: UIViewController {
  
  let state: RewardsState
  
  init(state: RewardsState) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: -
  
  var walletView: View {
    return view as! View
  }
  
  override func loadView() {
    view = View(frame: UIScreen.main.bounds)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // FIXME: Only show these when we have notifications to show?
//    let notification = WalletNotificationView(
//      notification: WalletNotification(
//        category: .adsRewards,
//        body: "You’ve earned 10 BAT.",
//        date: Date()
//      )
//    )
//    notification.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
//    notification.actionButton.addTarget(self, action: #selector(tappedNotificationAction), for: .touchUpInside)
//    walletView.notificationView = notification
    
    // Not actually visible from this controller
    title = BATLocalizedString("BraveRewardsPanelTitle", "Rewards")
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    let rewardsSummaryView = walletView.rewardsSummaryView
    
    rewardsSummaryView.rewardsSummaryButton.addTarget(self, action: #selector(tappedRewardsSummaryButton), for: .touchUpInside)
    // FIXME: Set this disclaimer based on contributions going to unverified publishers
    let disclaimerText = String(format: BATLocalizedString("BraveRewardsContributingToUnverifiedSites", "You've designated %d BAT for creators who haven't yet signed up to recieve contributions. Your browser will keep trying to contribute until they verify, or until 90 days have passed."), 52)
    rewardsSummaryView.disclaimerView = DisclaimerView(text: disclaimerText)
    
    walletView.headerView.addFundsButton.addTarget(self, action: #selector(tappedAddFunds), for: .touchUpInside)
    walletView.headerView.settingsButton.addTarget(self, action: #selector(tappedSettings), for: .touchUpInside)
    walletView.headerView.grantsButton.addTarget(self, action: #selector(tappedGrantsButton), for: .touchUpInside)
    
    // FIXME: Remove temp values
    walletView.headerView.setWalletBalance("30.0", crypto: "BAT", dollarValue: "0.00 USD")
    
    rewardsSummaryView.monthYearLabel.text = "MARCH 2019"
    rewardsSummaryView.rows = [
      RowView(title: "Total Grants Claimed Total Grants Claimed", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Earnings from Ads", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Auto-Contribute", batValue: "-10.0", usdDollarValue: "-5.25"),
      RowView(title: "One-Time Tips", batValue: "-2.0", usdDollarValue: "-1.05"),
      RowView(title: "Monthly Tips", batValue: "-19.0", usdDollarValue: "-9.97"),
    ]
    
    reloadUIState()
    view.layoutIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if presentedViewController == nil {
      navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    reloadUIState()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if presentedViewController == nil {
      navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    walletView.headerView.layoutIfNeeded()
    walletView.contentView?.layoutIfNeeded()
    
    guard let contentView = walletView.contentView else { return }
    
    var height: CGFloat = walletView.headerView.bounds.height + walletView.rewardsSummaryView.rewardsSummaryButton.bounds.height
    if let scrollView = walletView.contentView?.innerScrollView {
      scrollView.contentInset = UIEdgeInsets(top: walletView.headerView.bounds.height, left: 0, bottom: 0, right: 0)
      scrollView.scrollIndicatorInsets = scrollView.contentInset
      
      height += scrollView.contentSize.height
    } else {
      height += contentView.bounds.height
    }
    
    if state.ledger.isEnabled {
      height = RewardsUX.preferredPanelSize.height
    }
    
    let newSize = CGSize(width: RewardsUX.preferredPanelSize.width, height: height)
    if preferredContentSize != newSize {
      preferredContentSize = newSize
    }
  }
  
  // MARK: -
  
  private lazy var publisherSummaryView = PublisherSummaryView().then(setupPublisherView)
  private lazy var rewardsDisabledView = RewardsDisabledView()
  
  func setupPublisherView(_ publisherSummaryView: PublisherSummaryView) {
    publisherSummaryView.tipButton.addTarget(self, action: #selector(tappedSendTip), for: .touchUpInside)
    
    let publisherView = publisherSummaryView.publisherView
    let attentionView = publisherSummaryView.attentionView
    
    publisherView.setVerificationStatusHidden(isLocal)
    
    publisherSummaryView.setLocal(isLocal)
    if !isLocal {
      publisherView.publisherNameLabel.text = state.dataSource?.displayString(for: state.url)
      
      // FIXME: Remove fake data
      publisherView.setVerified(true)
      attentionView.valueLabel.text = "19%"
      
      if let faviconURL = state.faviconURL {
        state.dataSource?.retrieveFavicon(with: faviconURL, completion: { [weak self] image in
          self?.publisherSummaryView.publisherView.faviconImageView.image = image
        })
      }
    }
  }
  
  var isLocal: Bool {
    return state.url.host == "127.0.0.1" || state.url.host == "localhost"
  }
  
  func reloadUIState() {
    if state.ledger.isEnabled {
      walletView.contentView = publisherSummaryView
    } else {
      if rewardsDisabledView.enableRewardsButton.allTargets.count == 0 {
        rewardsDisabledView.enableRewardsButton.addTarget(self, action: #selector(tappedEnableBraveRewards), for: .touchUpInside)
      }
      walletView.contentView = rewardsDisabledView
    }
  }
  
  // MARK: - Actions
  
  @objc private func tappedNotificationClose() {
    self.walletView.setNotificationView(nil, animated: true)
  }
  
  @objc private func tappedNotificationAction() {
    // TODO: Do something with the notification
    self.walletView.setNotificationView(nil, animated: true)
  }
  
  @objc private func tappedGrantsButton() {
    let controller = GrantsListViewController(ledger: state.ledger)
    navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc private func tappedAddFunds() {
    let controller = AddFundsViewController(state: state)
    let container = PopoverNavigationController(rootViewController: controller)
    present(container, animated: true)
  }
  
  @objc private func tappedSettings() {
    let controller = SettingsViewController(state: state)
    navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc private func tappedSendTip() {
    let controller = TippingViewController(state: state, publisherId: "") // TODO: pass publisher Id
    state.delegate?.presentBraveRewardsController(controller)
  }
  
  @objc private func tappedEnableBraveRewards() {
    state.ledger.isEnabled = true
    reloadUIState()
  }
  
  @objc private func tappedRewardsSummaryButton() {
    let contentView = walletView.contentView
    let rewardsSummaryView = walletView.rewardsSummaryView
    
    let isExpanding = rewardsSummaryView.transform.ty == 0;
    rewardsSummaryView.rewardsSummaryButton.slideToggleImageView.image =
      UIImage(frameworkResourceNamed: isExpanding ? "slide-down" : "slide-up")
    
    // Animating the rewards summary with a bit of a bounce
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: [], animations: {
      if (isExpanding) {
        rewardsSummaryView.transform = CGAffineTransform(
          translationX: 0,
          y: -self.walletView.summaryLayoutGuide.layoutFrame.height + rewardsSummaryView.rewardsSummaryButton.bounds.height
        )
      } else {
        rewardsSummaryView.transform = .identity
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
        contentView?.alpha = 0.0
        rewardsSummaryView.monthYearLabel.alpha = 1.0
        self.view.backgroundColor = Colors.blurple800
      } else {
        contentView?.alpha = 1.0
        rewardsSummaryView.monthYearLabel.alpha = 0.0
        self.view.backgroundColor = .white
      }
    }) { _ in
      rewardsSummaryView.monthYearLabel.isHidden = !(rewardsSummaryView.monthYearLabel.alpha > 0.0)
      rewardsSummaryView.alpha = 1.0
    }
  }
}
