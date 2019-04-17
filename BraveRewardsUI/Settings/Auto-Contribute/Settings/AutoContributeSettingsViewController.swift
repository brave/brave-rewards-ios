/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class AutoContributeSettingsViewController: UIViewController {
  
  private let ledger: BraveLedger
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  var contentView: View {
    return view as! View
  }
  
  override func loadView() {
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = self
    
    contentView.allowUnverifiedContributionsSwitch.isOn = ledger.allowUnverifiedPublishers
    contentView.allowVideoContributionsSwitch.isOn = ledger.allowVideoContributions
    
    contentView.minimumLengthCell.accessoryLabel?.text =
      String(format: BATLocalizedString("BraveRewardsAutoContributeMinimumLengthValue", "%d seconds"), ledger.minimumVisitDuration)
    contentView.minimumVisitsCell.accessoryLabel?.text =
      String(format: BATLocalizedString("BraveRewardsAutoContributeMinimumVisitsValue", "%d visits"), ledger.minimumNumberOfVisits)
    
    if let walletInfo = ledger.walletInfo, let dollarAmount = ledger.dollarStringForBATAmount(ledger.contributionAmount) {
      contentView.monthlyPaymentCell.accessoryLabel?.text = "\(ledger.contributionAmount) \(walletInfo.altcurrency) (\(dollarAmount))"
    }
    
    contentView.allowVideoContributionsSwitch.addTarget(self, action: #selector(allowVideoValueChanged), for: .valueChanged)
    contentView.allowUnverifiedContributionsSwitch.addTarget(self, action: #selector(allowUnverifiedValueChanged), for: .valueChanged)
  }
  
  var rows: [UITableViewCell] {
    return [
      contentView.monthlyPaymentCell,
      contentView.minimumLengthCell,
      contentView.minimumVisitsCell,
      contentView.allowUnverifiedContributionsCell,
      contentView.allowVideoContributionsCell
    ]
  }
  
  // MARK: - Actions
  
  @objc private func allowUnverifiedValueChanged() {
    ledger.allowUnverifiedPublishers = contentView.allowUnverifiedContributionsSwitch.isOn
  }
  
  @objc private func allowVideoValueChanged() {
    ledger.allowVideoContributions = contentView.allowVideoContributionsSwitch.isOn
  }
}

extension AutoContributeSettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return rows[indexPath.row]
  }
}

extension AutoContributeSettingsViewController {
  class View: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      tableView.backgroundView = UIView().then { $0.backgroundColor = SettingsUX.backgroundColor }
      
      tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
      tableView.separatorStyle = .none
      addSubview(tableView)
      tableView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      tableView.layoutMargins = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
    
    let monthlyPaymentCell = TableViewCell(style: .value1, reuseIdentifier: nil).then {
      $0.label.text = BATLocalizedString("BraveRewardsAutoContributeMonthlyPayment", "Monthly payment")
      $0.label.font = SettingsUX.bodyFont
      $0.label.numberOfLines = 0
      $0.label.lineBreakMode = .byWordWrapping
      $0.accessoryLabel?.textColor = Colors.grey100
      $0.accessoryLabel?.font = SettingsUX.bodyFont
      $0.accessoryType = .disclosureIndicator
    }
    
    let minimumLengthCell = TableViewCell(style: .value1, reuseIdentifier: nil).then {
      $0.label.text = BATLocalizedString("BraveRewardsAutoContributeMinimumLength", "Minimum page time before logging a visit")
      $0.label.font = SettingsUX.bodyFont
      $0.label.lineBreakMode = .byWordWrapping
      $0.label.numberOfLines = 0
      $0.accessoryLabel?.textColor = Colors.grey100
      $0.accessoryLabel?.font = SettingsUX.bodyFont
      $0.accessoryType = .disclosureIndicator
    }
   
    let minimumVisitsCell = TableViewCell(style: .value1, reuseIdentifier: nil).then {
      $0.label.text = BATLocalizedString("BraveRewardsAutoContributeMinimumVisits", "Minimum visits for publisher relavancy")
      $0.label.font = SettingsUX.bodyFont
      $0.label.lineBreakMode = .byWordWrapping
      $0.label.numberOfLines = 0
      $0.accessoryLabel?.textColor = Colors.grey100
      $0.accessoryLabel?.font = SettingsUX.bodyFont
      $0.accessoryType = .disclosureIndicator
    }
    
    let allowUnverifiedContributionsSwitch = UISwitch().then {
      $0.onTintColor = BraveUX.braveOrange
    }
    lazy var allowUnverifiedContributionsCell = TableViewCell().then {
      $0.label.text = BATLocalizedString("BraveRewardsAutoContributeToUnverifiedSites", "Allow contributions to non-verified sites")
      $0.label.font = SettingsUX.bodyFont
      $0.label.lineBreakMode = .byWordWrapping
      $0.label.numberOfLines = 0
      $0.accessoryView = allowUnverifiedContributionsSwitch
      $0.selectionStyle = .none
    }
    
    let allowVideoContributionsSwitch = UISwitch().then {
      $0.onTintColor = BraveUX.braveOrange
    }
    lazy var allowVideoContributionsCell = TableViewCell().then {
      $0.label.text = BATLocalizedString("BraveRewardsAutoContributeToVideos", "Allow contribution to videos")
      $0.label.font = SettingsUX.bodyFont
      $0.label.numberOfLines = 0
      $0.accessoryView = allowVideoContributionsSwitch
      $0.selectionStyle = .none
    }
  }
}
