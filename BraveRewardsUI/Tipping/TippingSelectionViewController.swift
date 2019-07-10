// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import UIKit
import BraveRewards

class TippingSelectionViewController: OptionsSelectionViewController {
  
  private let state: RewardsState?
  
  // Hide the super constructor with `DisplayableOption`
  // in favour of our constructor with `BatValue`
  private override init(options: [DisplayableOption],
                        selectedOptionIndex: Int = 0,
                        optionSelected: @escaping (_ selectedIndex: Int) -> Void) {
    self.state = nil
    super.init(options: options, selectedOptionIndex: selectedOptionIndex, optionSelected: optionSelected)
  }
  
  init(state: RewardsState, options: [BATValue],
       selectedOptionIndex: Int = 0,
       optionSelected: @escaping (_ selectedIndex: Int) -> Void) {
    self.state = state
    super.init(options: options, selectedOptionIndex: selectedOptionIndex, optionSelected: optionSelected)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Recurring Tips"
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
    cell.textLabel?.text = options[indexPath.row].displayString
    cell.textLabel?.font = .systemFont(ofSize: 14.0)
    cell.textLabel?.textColor = Colors.grey100
    cell.textLabel?.numberOfLines = 0
    cell.accessoryType = selectedOptionIndex == indexPath.row ? .checkmark : .none
    
    guard let options = options as? [BATValue] else { return cell }
    let displayString = options[indexPath.row].displayString
    let dollarAmount = state?.ledger.dollarStringForBATAmount(options[indexPath.row].doubleValue) ?? ""
    
    let attributedText = NSMutableAttributedString(string: displayString, attributes: [
      .foregroundColor: Colors.grey100,
      .font: UIFont.systemFont(ofSize: 14.0, weight: .medium)
    ])
    
    attributedText.append(NSAttributedString(string: " BAT", attributes: [
      .foregroundColor: Colors.grey200,
      .font: UIFont.systemFont(ofSize: 12.0)
    ]))
    
    attributedText.append(NSAttributedString(string: " (\(dollarAmount))", attributes: [
      .foregroundColor: Colors.grey200,
      .font: UIFont.systemFont(ofSize: 10.0)
    ]))
    
    cell.textLabel?.attributedText = attributedText
    return cell
  }
}
