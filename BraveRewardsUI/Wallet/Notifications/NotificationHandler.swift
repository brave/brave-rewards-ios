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
  private weak var delegate: NotificationHandlerDelegate?
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  weak var currentNotification: RewardsNotification?
  
  func start(delegate: NotificationHandlerDelegate) {
    //Stopping as a precaution
    stop()
    // Add observer
    currentNotification = nil
    self.delegate = delegate
    NotificationCenter.default.addObserver(self, selector: #selector(notificationAdded(_:)), name: NSNotification.Name.BATBraveLedgerNotificationAdded, object: nil)
    loadNextNotification()
  }
  
  func stop() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BATBraveLedgerNotificationAdded, object: nil)
    delegate = nil
  }
  
  @objc private func notificationAdded(_ notification: Notification) {
    // TODO: Filter notification?
    if currentNotification == nil {
      loadNextNotification()
    }
  }
  
  private func clearCurrentNotification() {
    if let currentNotification = currentNotification {
      ledger.clearNotification(currentNotification)
      self.currentNotification = nil
    }
  }
  
  private func loadNextNotification() {
    clearCurrentNotification()
    
    //.failedContribution, .invalid & .backupWallet are not supported right now
    // TODO: Verify that notifications are ordered & they are displayed in FIFO.
    let ignoredRewardNotificationTypes: [RewardsNotification.Kind] = [.failedContribution,
                                                                      .invalid,
                                                                      .backupWallet]
    if let notification = ledger.notifications.first(where: {
      !ignoredRewardNotificationTypes.contains($0.kind)
    }) {
      currentNotification = notification
      switch notification.kind {
      case .autoContribute, .tipsProcessed, .verifiedPublisher:
        add(messageNotification: notification)
      case .grant, .grantAds, .insufficientFunds, .pendingNotEnoughFunds, .adsLaunch:
        add(actionNotification: notification)
      default:
        return
      }
    } else {
      delegate?.hideNotifications()
    }
  }
  
  private func add(actionNotification: RewardsNotification) {
    let category: WalletActionNotification.Category
    let body: String
    
    switch actionNotification.kind {
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
    default:
      assertionFailure("Undefined case for action notification")
      return
    }
    let date = Date(timeIntervalSince1970: actionNotification.dateAdded)
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
    loadNextNotification()
  }
  
  @objc private func tappedNotificationAction() {
    if let notification = currentNotification {
      delegate?.handleAction(notification: notification)
      loadNextNotification()
    }
  }
  
  private func add(messageNotification: RewardsNotification) {
    var category: WalletMessageNotification.Category
    let body: String
    var alertType: WalletAlertNotification.Category?
    switch messageNotification.kind {
    case .autoContribute:
      if let result = messageNotification.userInfo["result"] as? Int, let amount = messageNotification.userInfo["amount"] as? String {
        category = .contribute
        switch result {
        case 0:
          body = String.localizedStringWithFormat(Strings.NotificationContributeSuccess, amount)
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
        loadNextNotification()
        return
      }
    case .tipsProcessed:
      body = Strings.NotificationTipsProcessedBody
      category = .tipsProcessed
    case .verifiedPublisher:
      // FIXME: Verify key
      if let name = messageNotification.userInfo["name"] as? String {
        body = String.localizedStringWithFormat(Strings.NotificationVerifiedPublisherBody, name)// publisher name"
        category = .verifiedPublisher
      } else {
        loadNextNotification()
        return
      }
    default:
      assertionFailure("Undefined case for message notification")
      return
    }
    if let type = alertType {
      showAlertNotification(type: type, message: body)
      return
    }
    
    let date = Date(timeIntervalSince1970: messageNotification.dateAdded)
    let notificationView = WalletMessageNotificationView(
      notification: WalletMessageNotification(
        category: category,
        body: body,
        date: date
      )
    )
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
