// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards

protocol NotificationHandlerDelegate: AnyObject {
  func show(notificationView: WalletNotificationView)
  func handleAction(notification: RewardsNotification)
  func hideNotifications()
}

class NotificationHandler {

  private var ledger: BraveLedger
  weak var delegate: NotificationHandlerDelegate?
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
  }
  
  deinit {
    stop()
  }
  
  weak var currrentNotification: RewardsNotification?
  
  func start() {
    // Add observer
    stop()
    NotificationCenter.default.addObserver(self, selector: #selector(notificationAdded(_:)), name: .init(rawValue: "BATBraveLedgerNotificationAdded"), object: nil)
    loadNotification()
  }
  
  private func stop() {
    NotificationCenter.default.removeObserver(self, name: .init(rawValue: "BATBraveLedgerNotificationAdded"), object: nil)
  }
  
  @objc private func notificationAdded(_ notification: Notification) {
    // TODO: Filter notification?
    if currrentNotification == nil {
      loadNotification()
    }
  }
  
  private func loadNotification() {
    guard delegate != nil else {
      return
    }
    if let currrentNotification = currrentNotification {
      ledger.clearNotification(currrentNotification)
      self.currrentNotification = nil
    }
    
    //.failedContribution, .invalid & .backupWallet are not supported right now
    // TODO: Verify that notifications are ordered & they are displayed in FIFO.
    let ignoredRewardNotificationTypes: [RewardsNotification.Kind] = [.failedContribution,
                                                                      .invalid,
                                                                      .backupWallet]
    let notification = ledger.notifications
    if let notification = notification.first(where: {
      !ignoredRewardNotificationTypes.contains($0.kind)
    }) {
      currrentNotification = notification
      switch notification.kind {
      case .autoContribute, .tipsProcessed, .verifiedPublisher:
        addMessageNotification(notification: notification)
      case .grant, .grantAds, .insufficientFunds, .pendingNotEnoughFunds, .adsLaunch:
        addActionNotification(notification: notification)
      default:
        return
      }
    } else {
      delegate?.hideNotifications()
    }
  }
  
  private func addActionNotification(notification: RewardsNotification) {
    let category: WalletActionNotification.Category
    let body: String
    
    switch notification.kind {
    case .grant:
      body = Strings.NotificationGrantNotification
      category = .grant
    case .grantAds:
      body = Strings.NotificationEarningsClaimDefault
      category = .grant
    case .insufficientFunds:
      body = Strings.NotificationInsufficientFunds
      category = .insufficientFunds
    case .pendingNotEnoughFunds:
      body = Strings.NotificationPendingNotEnoughFunds
      category = .insufficientFunds
    case .adsLaunch:
      body = Strings.NotificationBraveAdsLaunchMsg
      category = .adsLaunch
    default:
      loadNotification()
      return
    }
    let date = Date(timeIntervalSince1970: notification.dateAdded)
    let notificationView = WalletActionNotificationView(
      notification: WalletActionNotification(
        category: category,
        body: body,
        date: date))
    notificationView.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
    notificationView.actionButton.addTarget(self, action: #selector(tappedNotificationAction), for: .touchUpInside)
    delegate?.show(notificationView: notificationView)
  }
  
  @objc private func tappedNotificationClose() {
    loadNotification()
  }
  
  @objc private func tappedNotificationAction() {
    if let notification = currrentNotification {
      loadNotification()
      delegate?.handleAction(notification: notification)
    }
  }
  
  private func addMessageNotification(notification: RewardsNotification) {
    var category: WalletNotification.Category = .contribute
    let body: String
    var alertType: WalletAlertNotification.Category?
    switch notification.kind {
    case .autoContribute:
      if let result = notification.userInfo["result"] as? Int, let amount = notification.userInfo["amount"] as? String {
        switch result {
        case 0:
          body = String.localizedStringWithFormat(Strings.NotificationContributeSuccess, amount)
          category = .contribute
        case 15:
          body = Strings.NotificationAutoContributeNotEnoughFundsBody
          alertType = .warning
        case 16:
          body = Strings.NotificationContributeTipError
          alertType = .error
        default:
          body = Strings.NotificationContributeError
          alertType = .error
        }
      } else {
        loadNotification()
        return
      }
    case .tipsProcessed:
      body = Strings.NotificationTipsProcessedBody
      category = .tipsProcessed
    case .verifiedPublisher:
      // FIXME: Verify key
      if let name = notification.userInfo["name"] as? String {
        body = String.localizedStringWithFormat(Strings.NotificationVerifiedPublisherBody, name)// publisher name"
        category = .verifiedPublisher
      } else {
        loadNotification()
        return
      }
    default:
      loadNotification()
      return
    }
    if let type = alertType {
      showAlertNotification(type: type, message: body)
      return
    }
    
    let date = Date(timeIntervalSince1970: notification.dateAdded)
    let notificationView = WalletNotificationView(
      notification: WalletNotification(
        category: category,
        body: body,
        date: date))
    notificationView.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
    delegate?.show(notificationView: notificationView)
  }
  
  private func showAlertNotification(type: WalletAlertNotification.Category, message: String) {
    let notificationView = WalletAlertNotificationView(
      notification: WalletAlertNotification(
        category: type,
        title: nil,
        body: message
      )
    )
    notificationView.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
    delegate?.show(notificationView: notificationView)
  }
}
