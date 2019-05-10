/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

/// Shared resources for showing summary of all BAT rewards.
protocol RewardsSummaryProtocol {
  var state: RewardsState { get }
  
  /// Month and year of which the rewards summary is shown.
  var summaryPeriod: String { get }
  
  /// Rows showing different types of earnings, tips etc.
  var summaryRows: [RowView] { get }
  
  /// A view informing users about contributing to unverified publishers.
  var disclaimerView: DisclaimerView? { get }
}

extension RewardsSummaryProtocol {
  var summaryPeriod: String {
    let now = Date()
    return "\(now.currentMonthName().uppercased()) \(now.currentYear)"
  }
  
  var summaryRows: [RowView] {
    // FIXME: Remove temp values
    return [
      RowView(title: "Total Grants Claimed Total Grants Claimed", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Earnings from Ads", batValue: "10.0", usdDollarValue: "5.25"),
      RowView(title: "Auto-Contribute", batValue: "-10.0", usdDollarValue: "-5.25"),
      RowView(title: "One-Time Tips", batValue: "-2.0", usdDollarValue: "-1.05"),
      RowView(title: "Monthly Tips", batValue: "-19.0", usdDollarValue: "-9.97"),
    ]
  }
  
  var disclaimerView: DisclaimerView? {
    // FIXME: Set this disclaimer based on contributions going to unverified publishers
    // if !state.ledger.isAutoContributeEnabled { return nil }
    
    let text = String(format: BATLocalizedString("BraveRewardsContributingToUnverifiedSites", "You've designated %d BAT for creators who haven't yet signed up to recieve contributions. Your browser will keep trying to contribute until they verify, or until 90 days have passed."), 52)
    
    return DisclaimerView(text: text)
  }
}
