/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import BraveRewards

extension BraveLedger {
  
  /// Gets the dollar string for some BAT amount using rates from the users wallet with the
  /// currency code appended (i.e. "6.42 USD")
  func dollarStringForBATAmount(_ amount: Double, currencyCode: String = "USD") -> String? {
    guard let walletInfo = walletInfo,
          let conversionRate = walletInfo.rates[currencyCode]?.doubleValue else {
      return nil
    }
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.currencySymbol = ""
    currencyFormatter.numberStyle = .currency
    let valueString = currencyFormatter.string(from: NSNumber(value: amount * conversionRate)) ?? "0.00"
    return "\(valueString) \(currencyCode)"
  }
  
  /// Options around minimum visits for publisher relavancy
  enum MinimumVisitsOptions: UInt32, CaseIterable, DisplayableOption {
    case one = 1
    case five = 5
    case ten = 10
    
    var displayString: String {
      switch self {
      case .one: return BATLocalizedString("BraveRewardsMinimumVisitsChoices0", "1 visit")
      case .five: return BATLocalizedString("BraveRewardsMinimumVisitsChoices1", "5 visits")
      case .ten: return BATLocalizedString("BraveRewardsMinimumVisitsChoices2", "10 visits")
      }
    }
  }
  
  /// Options around minimum page time before logging a visit (in seconds)
  enum MinimumVisitDurationOptions: UInt64, CaseIterable, DisplayableOption {
    case fiveSeconds = 5
    case eightSeconds = 8
    case oneMinute = 60
    
    var displayString: String {
      switch self {
      case .fiveSeconds: return BATLocalizedString("BraveRewardsMinimumLengthChoices0", "5 seconds")
      case .eightSeconds: return BATLocalizedString("BraveRewardsMinimumLengthChoices1", "8 seconds")
      case .oneMinute: return BATLocalizedString("BraveRewardsMinimumLengthChoices2", "1 minute")
      }
    }
  }
}
