// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards

struct RewardsNotificationViewBuilder {
  
  static func get(notification: RewardsNotification) -> WalletNotificationView? {
    switch notification.kind {
    case .autoContribute, .tipsProcessed, .verifiedPublisher:
      return RewardsNotificationViewBuilder.get(messageNotification: notification)
    case .grant, .grantAds, .insufficientFunds, .pendingNotEnoughFunds, .adsLaunch:
      return RewardsNotificationViewBuilder.get(actionNotification: notification)
    default:
      return nil
    }
  }
  
  private static func get(actionNotification: RewardsNotification) -> WalletNotificationView? {
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
      return nil
    }
    let date = Date(timeIntervalSince1970: actionNotification.dateAdded)
    return WalletActionNotificationView(
      notification: WalletActionNotification(
        category: category,
        body: body,
        date: date))
  }
  
  private static func get(messageNotification: RewardsNotification) -> WalletNotificationView? {
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
        assertionFailure("Auto Contribute notification has invalid userInfo")
        return nil
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
        assertionFailure("Verified publisher notification has invalid userInfo")
        return nil
      }
    default:
      assertionFailure("Undefined case for message notification")
      return nil
    }
    if let type = alertType {
      return WalletAlertNotificationView(
        notification: WalletAlertNotification(
          category: type,
          title: nil,
          body: body
        )
      )
    }
    
    let date = Date(timeIntervalSince1970: messageNotification.dateAdded)
    let notificationView = WalletMessageNotificationView(
      notification: WalletMessageNotification(
        category: category,
        body: body,
        date: date
      )
    )
    return notificationView
  }
}
