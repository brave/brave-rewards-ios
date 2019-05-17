/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import BraveRewards

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
    let now = Date()
    guard let activityMonth = ActivityMonth(rawValue: now.currentMonthNumber) else {
      return []
    }
    
    let ledger = state.ledger
    let balance = ledger.balanceReport(for: activityMonth, year: Int32(now.currentYear))
    
    let activityQualifiers = [
      balance.grants,
      balance.earningFromAds,
      balance.autoContribute,
      balance.oneTimeDonation,
      balance.recurringDonation
    ]
    
    // Convert to double to avoid any issues with changing what the "0" string is (i.e. if it were
    // to change to "0.00")
    if activityQualifiers.first(where: { BATValue($0)?.doubleValue != 0 }) == nil {
      // No activity
      return []
    }
    
    // In case ledger doesn't provide parseable String balance, we have to use some kind of fallback.
    // Using 0.0 for fallback there may scare users that their tokens are gone, while this is only
    // a display bug.
    let fallback = "-"
    
    // Brave TODO: String localization(#19)
    
    let grantsValue = BATValue(balance.grants)
    let grantsBAT = grantsValue?.displayString ?? fallback
    let grantsUSD = ledger.dollarStringForBATAmount(grantsBAT)
    let grantsRow = RowView(title: "Total Grants Claimed", cryptoValueColor: BraveUX.adsTintColor,
                            batValue: grantsBAT, usdDollarValue: grantsUSD)
    
    let adsEarningsValue = BATValue(balance.earningFromAds)
    let adsEarningsBAT = adsEarningsValue?.displayString ?? fallback
    let adsEarningsUSD = ledger.dollarStringForBATAmount(adsEarningsBAT)
    let adsEarningsRow = RowView(title: "Earnings from Ads", cryptoValueColor: BraveUX.adsTintColor,
                                 batValue: adsEarningsBAT, usdDollarValue: adsEarningsUSD)
    
    let autoContributeValue = BATValue(balance.autoContribute)
    let autoContributeBAT = autoContributeValue?.displayString ?? fallback
    let autoContributeUSD = ledger.dollarStringForBATAmount(autoContributeBAT)
    let autoContributeRow = RowView(title: "Auto-Contribute",
                                    cryptoValueColor: BraveUX.autoContributeTintColor,
                                    batValue: autoContributeBAT, usdDollarValue: autoContributeUSD)
    
    let oneTimeTipsValue = BATValue(balance.oneTimeDonation)
    let oneTimeTipsBAT = oneTimeTipsValue?.displayString ?? fallback
    let oneTimeTipsUSD = ledger.dollarStringForBATAmount(oneTimeTipsBAT)
    let oneTimeTipsRow = RowView(title: "One-Time Tips", cryptoValueColor: BraveUX.tipsTintColor,
                                 batValue: oneTimeTipsBAT, usdDollarValue: oneTimeTipsUSD)
    
    let monthlyTipsValue = BATValue(balance.recurringDonation)
    let monthlyTipsBAT = monthlyTipsValue?.displayString ?? fallback
    let monthlyTipsUSD = ledger.dollarStringForBATAmount(monthlyTipsBAT)
    let monthlyTipsRow = RowView(title: "Monthly Tips", cryptoValueColor: BraveUX.tipsTintColor,
                                 batValue: monthlyTipsBAT, usdDollarValue: monthlyTipsUSD)
    
    return [grantsRow, adsEarningsRow, autoContributeRow, oneTimeTipsRow, monthlyTipsRow]
  }
  
  var disclaimerView: DisclaimerView? {
    // FIXME: Set this disclaimer based on contributions going to unverified publishers
    // if !state.ledger.isAutoContributeEnabled { return nil }
    
    let text = String(format: Strings.ContributingToUnverifiedSites, 52)
    
    return DisclaimerView(text: text)
  }
}
