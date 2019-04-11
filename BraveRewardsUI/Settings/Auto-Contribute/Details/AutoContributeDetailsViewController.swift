/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

import BraveRewards

class AutoContributeDetailViewController: UIViewController {
  
  private var contentView: View {
    return view as! View
  }
  
  // Just copy pasted this in, needs design specific for auto-contribute
  
  private let ledger: BraveLedger
  
  init(ledger: BraveLedger) {
    self.ledger = ledger
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = self
    
    title = BATLocalizedString("BraveRewardsAutoContribute", "Auto-Contribute")
    
    let dateFormatter = DateFormatter().then {
      $0.dateStyle = .short
      $0.timeStyle = .none
    }
    
    // FIXME: Remove temp values
    nextContributionDateLabel.label.text = dateFormatter.string(from: Date().addingTimeInterval(60*60*24*12))
    nextContributionDateLabel.bounds = CGRect(origin: .zero, size: nextContributionDateLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize))
    
    supportedSitesCell.detailTextLabel?.attributedText = totalSitesAttributedString(from: 0)
  }
  
  private func totalSitesAttributedString(from total: Int) -> NSAttributedString {
    let format = String(format: BATLocalizedString("BraveRewardsTotalSites", "Total %ld"), total)
    let s = NSMutableAttributedString(string: format)
    guard let range = format.range(of: String(total)) else { return s }
    s.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(range, in: format))
    return s
  }
  
  private let headerView = TableHeaderRowView(
    columns: [
      TableHeaderRowView.Column(
        title: BATLocalizedString("BraveRewardsSite", "Site").uppercased(),
        width: .percentage(0.7)
      ),
      TableHeaderRowView.Column(
        title: BATLocalizedString("BraveRewardsAttention", "Attention").uppercased(),
        width: .percentage(0.3),
        align: .right
      ),
    ],
    tintColor: BraveUX.autoContributeTintColor
  )
  
  private let settingsCell = AutoContributeSummaryTableCell().then {
    $0.textLabel?.text = BATLocalizedString("BraveRewardsSettings", "Settings")
    $0.textLabel?.font = SettingsUX.bodyFont
    $0.imageView?.image = UIImage(frameworkResourceNamed: "settings").alwaysTemplate
    $0.imageView?.tintColor = BraveUX.autoContributeTintColor
    $0.accessoryType = .disclosureIndicator
  }
  
  private let monthlyPaymentCell = AutoContributeSummaryTableCell().then {
    $0.textLabel?.text = BATLocalizedString("BraveRewardsAutoContributeMonthlyPayment", "Monthly payment")
    $0.textLabel?.font = SettingsUX.bodyFont
    $0.accessoryType = .disclosureIndicator
  }
  
  private let nextContributionDateLabel =  NextContributionDateView()
  
  private lazy var nextContributeDateCell = AutoContributeSummaryTableCell().then {
    $0.textLabel?.text = BATLocalizedString("BraveRewardsAutoContributeNextDate", "Next contribution date")
    $0.textLabel?.font = SettingsUX.bodyFont
    $0.selectionStyle = .none
    $0.accessoryView = nextContributionDateLabel
  }
  
  private let supportedSitesCell = AutoContributeSummaryTableCell(style: .value1, reuseIdentifier: nil).then {
    $0.textLabel?.text = BATLocalizedString("BraveRewardsAutoContributeSupportedSites", "Supported sites")
    $0.textLabel?.font = SettingsUX.bodyFont
    $0.detailTextLabel?.textColor = Colors.grey100
    $0.detailTextLabel?.font = SettingsUX.bodyFont
    $0.selectionStyle = .none
  }
}

extension AutoContributeDetailViewController: UITableViewDataSource, UITableViewDelegate {
  private enum Section: Int, CaseIterable {
    case summary
    case contributions
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let typedSection = Section(rawValue: section), typedSection == .contributions else { return nil }
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let typedSection = Section(rawValue: section), typedSection == .contributions else { return 0.0 }
    return headerView.systemLayoutSizeFitting(
      CGSize(width: tableView.bounds.width, height: tableView.bounds.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    ).height
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let typedSection = Section(rawValue: section) else { return 0 }
    switch typedSection {
    case .summary:
      return 4
    case .contributions:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      assertionFailure()
      return UITableViewCell()
    }
    switch section {
    case .summary:
      let cells = [settingsCell, monthlyPaymentCell, nextContributeDateCell, supportedSitesCell]
      if indexPath.row < cells.count {
        return cells[indexPath.row]
      }
      return UITableViewCell()
    case .contributions:
      let cell = tableView.dequeueReusableCell(for: indexPath) as EmptyTableCell
      cell.label.text = BATLocalizedString("BraveRewardsEmptyAutoContribution", "Sites will appear as you browse1")
      return cell
    }
  }
}

extension AutoContributeDetailViewController {
  class View: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      tableView.separatorStyle = .none
      tableView.register(AutoContributeSummaryTableCell.self)
      tableView.register(EmptyTableCell.self)
      tableView.layoutMargins = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
      
      addSubview(tableView)
      tableView.snp.makeConstraints {
        $0.edges.equalTo(self)
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}

private class NextContributionDateView: UIView {
  let label = UILabel().then {
    $0.textColor = Colors.grey100
    $0.font = .systemFont(ofSize: 14.0, weight: .medium)
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 6.0
    backgroundColor = Colors.grey900
    addSubview(label)
    label.snp.makeConstraints {
      $0.edges.equalTo(self).inset(UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
    }
  }
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}
