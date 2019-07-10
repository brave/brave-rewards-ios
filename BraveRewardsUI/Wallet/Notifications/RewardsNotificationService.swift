// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards

protocol RewardsNotificationServiceDelegate: AnyObject {
  /// Show the notificationView provided
  func show(notificationView: WalletNotificationView)
  
  /// Callback for actionable notificationViews, params include the actual notification & a closure to handle async tasks
  /// delaying loadNextNotification call.
  func handleAction(notification: RewardsNotification, loadNext: @escaping () -> Void)
  
  /// Hide last provided notification View. The hasNext param tells if there is a pending notification
  func hideNotification(hasNext: Bool)
}

/// A class that provides its subscriber with one notification View at a time.
class RewardsNotificationService {

  private var ledger: BraveLedger
  private weak var delegate: RewardsNotificationServiceDelegate?
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  weak var currentNotification: RewardsNotification?
  
  func start(delegate: RewardsNotificationServiceDelegate) {
    // Stopping as a precaution
    stop()
    // Add observer
    self.delegate = delegate
    NotificationCenter.default.addObserver(self, selector: #selector(notificationAdded(_:)), name: NSNotification.Name.BATBraveLedgerNotificationAdded, object: nil)
    loadNextNotification()
  }
  
  func stop() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BATBraveLedgerNotificationAdded, object: nil)
    delegate = nil
    currentNotification = nil
  }
  
  @objc private func notificationAdded(_ notification: Notification) {
    // TODO: Filter notification?
    // LoadNext if there is no current notification
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
    //.failedContribution, .adsLaunch, .invalid & .backupWallet are not supported right now
    // TODO: Verify that notifications are ordered & they are displayed in FIFO.
    let ignoredRewardNotificationTypes: [RewardsNotification.Kind] = [.failedContribution,
                                                                      .invalid,
                                                                      .backupWallet,
                                                                      .adsLaunch]
    if let notification = ledger.notifications.first(where: {
      !ignoredRewardNotificationTypes.contains($0.kind)
    }) {
      delegate?.hideNotification(hasNext: true)
      currentNotification = notification
      if let notificationView = RewardsNotificationViewBuilder.get(notification: notification) {
        notificationView.closeButton.addTarget(self, action: #selector(tappedNotificationClose), for: .touchUpInside)
        (notificationView as? WalletActionNotificationView)?.actionButton.addTarget(self, action: #selector(tappedNotificationAction), for: .touchUpInside)
        delegate?.show(notificationView: notificationView)
      } else {
        clearCurrentNotification()
        loadNextNotification()
      }
    } else {
      delegate?.hideNotification(hasNext: false)
    }
  }
  
  @objc private func tappedNotificationClose() {
    clearCurrentNotification()
    loadNextNotification()
  }
  
  @objc private func tappedNotificationAction() {
    if let notification = currentNotification {
      delegate?.handleAction(notification: notification, loadNext: { [weak self] in
        self?.tappedNotificationClose()
      })
      clearCurrentNotification()
    }
  }
}
