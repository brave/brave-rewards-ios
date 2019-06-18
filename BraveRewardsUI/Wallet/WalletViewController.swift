/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import SnapKit

protocol WalletContentView: AnyObject {
  var innerScrollView: UIScrollView? { get }
  var displaysRewardsSummaryButton: Bool { get }
}

class WalletViewController: UIViewController, RewardsSummaryProtocol {
  
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
    return view as! View // swiftlint:disable:this force_cast
  }
  
  override func loadView() {
    view = View(frame: UIScreen.main.bounds)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // FIXME: Only show these when we have notifications to show?
//    let notification = WalletActionNotificationView(
//      notification: WalletActionNotification(
//        category: .adsRewards,
//        body: "You’ve earned 10 BAT.",
//        date: Date()
//      )
//    )
//    let notification = WalletMessageNotificationView(
//      notification: WalletMessageNotification(
//        category: .success,
//        title: "Wallet restored!",
//        body: "Your wallet key has been verified and loaded successfuly"
//      )
//    )
//    notification.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
//    notification.actionButton.addTarget(self, action: #selector(tappedNotificationAction), for: .touchUpInside)
//    walletView.notificationView = notification
    
    // Not actually visible from this controller
    title = Strings.PanelTitle
    
    if let grants = state.ledger.walletInfo?.grants, !grants.isEmpty {
      walletView.headerView.grantsButton.isHidden = false
    } else {
      walletView.headerView.grantsButton.isHidden = true
    }
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    let rewardsSummaryView = walletView.rewardsSummaryView
    
    rewardsSummaryView.rewardsSummaryButton.addTarget(self, action: #selector(tappedRewardsSummaryButton), for: .touchUpInside)
    rewardsSummaryView.disclaimerView = disclaimerView
    
    walletView.headerView.addFundsButton.addTarget(self, action: #selector(tappedAddFunds), for: .touchUpInside)
    walletView.headerView.settingsButton.addTarget(self, action: #selector(tappedSettings), for: .touchUpInside)
    walletView.headerView.grantsButton.addTarget(self, action: #selector(tappedGrantsButton), for: .touchUpInside)
    
    walletView.headerView.setWalletBalance(
      state.ledger.balanceString,
      crypto: "BAT",
      dollarValue: state.ledger.usdBalanceString
    )
    
    rewardsSummaryView.monthYearLabel.text = summaryPeriod
    rewardsSummaryView.rows = summaryRows
    
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
    publisherSummaryView.monthlyTipView.addTarget(self, action: #selector(tappedMonthlyTip), for: .touchUpInside)
    // TODO: Update with actual value below
    publisherSummaryView.monthlyTipView.batValueView.amountLabel.text = "5"
    let publisherView = publisherSummaryView.publisherView
    let attentionView = publisherSummaryView.attentionView
    
    publisherView.setVerificationStatusHidden(isLocal)
    
    publisherSummaryView.setLocal(isLocal)
    if !isLocal {
      publisherView.publisherNameLabel.text = state.dataSource?.displayString(for: state.url)
      
      guard let host = state.url.host else { return }
      attentionView.valueLabel.text = "0%"
      
      state.ledger.publisherInfo(forId: host) { info in
        guard let publisher = info else { return }
        assert(Thread.isMainThread)
        publisherView.setVerified(publisher.verified)
        
        if let percent = self.state.ledger.currentActivityInfo(withPublisherId: publisher.id)?.percent {
          attentionView.valueLabel.text = "\(percent)%"
        }
        
      }
      
      if let faviconURL = state.faviconURL {
        state.dataSource?.retrieveFavicon(with: faviconURL, completion: { [weak self] image in
          guard let image = image else { return }
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
      
      publisherSummaryView.updateViewVisibility(autoContributionEnabled: state.ledger.isAutoContributeEnabled)
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
  
  @objc private func tappedMonthlyTip() {
    // TODO: Replace with actual values.
    let options = [
      BATValue(1),
      BATValue(5),
      BATValue(10)
    ]
    let optionsVC = OptionsSelectionViewController(options: options, selectedOptionIndex: 1, optionSelected: { [weak self] index in
      // TODO: save selection and update UI
      guard let self = self else {
        return
      }
      self.navigationController?.popToViewController(self, animated: true)
      // swiftlint:ignore:next
      self.publisherSummaryView.monthlyTipView.batValueView.amountLabel.text = options[safe: index]?.displayString ?? options[0].displayString
    })
    
    self.navigationController?.pushViewController(optionsVC, animated: true)
  }
  
  @objc private func tappedEnableBraveRewards() {
    state.ledger.isEnabled = true
    reloadUIState()
  }
  
  @objc private func tappedRewardsSummaryButton() {
    let contentView = walletView.contentView
    let rewardsSummaryView = walletView.rewardsSummaryView
    
    let isExpanding = rewardsSummaryView.transform.ty == 0
    rewardsSummaryView.rewardsSummaryButton.slideToggleImageView.image =
      UIImage(frameworkResourceNamed: isExpanding ? "slide-down" : "slide-up")
    
    // Animating the rewards summary with a bit of a bounce
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: [], animations: {
      if isExpanding {
        rewardsSummaryView.transform = CGAffineTransform(
          translationX: 0,
          y: -self.walletView.summaryLayoutGuide.layoutFrame.height + rewardsSummaryView.rewardsSummaryButton.bounds.height
        )
      } else {
        rewardsSummaryView.transform = .identity
      }
    }, completion: nil)
    
    if isExpanding {
      // Prepare animation
      rewardsSummaryView.monthYearLabel.isHidden = false
      rewardsSummaryView.monthYearLabel.alpha = 0.0
    }
    // But animate the rest without a bounce (since it doesnt make sense)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [], animations: {
      if isExpanding {
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
