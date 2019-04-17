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
}
