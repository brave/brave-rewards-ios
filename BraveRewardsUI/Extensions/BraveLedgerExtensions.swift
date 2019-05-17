/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import BraveRewards

extension BraveLedger {
  /// Get the current BAT wallet balance for display
  var balanceString: String { return BATValue(balance).displayString }
  
  /// Get the current USD wallet balance for display
  var usdBalanceString: String {
    return dollarStringForBATAmount(balance) ?? ""
  }
  
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
  
  /// Takes BAT amount as String, and returns a String converted to selected currency.
  /// Returns '0.00' if the method failed or could not cast `amountString` as `Double`
  func dollarStringForBATAmount(_ amountString: String, currencyCode: String = "USD") -> String {
    guard let stringToDouble = Double(amountString) else { return "0.00" }
    return dollarStringForBATAmount(stringToDouble, currencyCode: currencyCode) ?? "0.00"
  }

  
  /// Options around minimum visits for publisher relavancy
  enum MinimumVisitsOptions: UInt32, CaseIterable, DisplayableOption {
    case one = 1
    case five = 5
    case ten = 10
    
    var displayString: String {
      switch self {
      case .one: return Strings.MinimumVisitsChoices0
      case .five: return Strings.MinimumVisitsChoices1
      case .ten: return Strings.MinimumVisitsChoices2
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
      case .fiveSeconds: return Strings.MinimumLengthChoices0
      case .eightSeconds: return Strings.MinimumLengthChoices1
      case .oneMinute: return Strings.MinimumLengthChoices2
      }
    }
  }
}
