/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

import BraveRewards

// FIXME: Remove this struct when real data is available
private struct UpcomingContribution {
  let imageURL: URL?
  let isVerified: Bool
  let site: String
  let attention: CGFloat
}

private let upcomingContributions = [
  UpcomingContribution(imageURL: nil, isVerified: true, site: "myetherwallet.com", attention: 0.3),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "theverge.com", attention: 0.2),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "amazon.com", attention: 0.1),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "reddit.com", attention: 0.1),
  UpcomingContribution(imageURL: nil, isVerified: true, site: "myetherwallet.com", attention: 0.05),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "theverge.com", attention: 0.05),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "amazon.com", attention: 0.05),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "reddit.com", attention: 0.05),
  UpcomingContribution(imageURL: nil, isVerified: true, site: "myetherwallet.com", attention: 0.025),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "theverge.com", attention: 0.025),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "amazon.com", attention: 0.025),
  UpcomingContribution(imageURL: nil, isVerified: false, site: "reddit.com", attention: 0.025)
]

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
    
    title = Strings.AutoContribute
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tappedEditButton))
    
    reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    reloadData()
  }
  
  func reloadData() {
    // FIXME: Remove temp values
    let dateFormatter = DateFormatter().then {
      $0.dateStyle = .short
      $0.timeStyle = .none
    }
    nextContributionDateView.label.text = dateFormatter.string(from: Date().addingTimeInterval(60*60*24*12))
    nextContributionDateView.bounds = CGRect(origin: .zero, size: nextContributionDateView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize))
    
    contentView.tableView.reloadData()
  }
  
  private func totalSitesAttributedString(from total: Int) -> NSAttributedString {
    let format = String(format: Strings.TotalSites, total)
    let s = NSMutableAttributedString(string: format)
    guard let range = format.range(of: String(total)) else { return s }
    s.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(range, in: format))
    return s
  }
  
  private let headerView = TableHeaderRowView(
    columns: [
      TableHeaderRowView.Column(
        title: Strings.Site.uppercased(),
        width: .percentage(0.7)
      ),
      TableHeaderRowView.Column(
        title: Strings.Attention.uppercased(),
        width: .percentage(0.3),
        align: .right
      ),
    ],
    tintColor: BraveUX.autoContributeTintColor
  )
  
  enum SummaryRows: Int, CaseIterable {
    case settings
    case monthlyPayment
    case nextContribution
    case supportedSites
    case excludedSites
    
    func dequeuedCell(from tableView: UITableView, indexPath: IndexPath) -> TableViewCell {
      switch self {
      case .monthlyPayment, .supportedSites:
        return tableView.dequeueReusableCell(for: indexPath) as Value1TableViewCell
      case .nextContribution, .settings, .excludedSites:
        return tableView.dequeueReusableCell(for: indexPath) as TableViewCell
      }
    }
    
    static func numberOrRows(_ isExcludingSites: Bool) -> Int {
      var cases = Set<SummaryRows>(SummaryRows.allCases)
      if !isExcludingSites {
        cases.remove(.excludedSites)
      }
      return cases.count
    }
  }
  
  private let nextContributionDateView =  NextContributionDateView()
  
  // MARK: - Actions
  
  @objc private func tappedEditButton() {
    contentView.tableView.setEditing(true, animated: true)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
  }
  
  @objc private func tappedDoneButton() {
    contentView.tableView.setEditing(false, animated: true)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tappedEditButton))
  }
}

extension AutoContributeDetailViewController: UITableViewDataSource, UITableViewDelegate {
  private enum Section: Int, CaseIterable {
    case summary
    case contributions
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let typedSection = Section(rawValue: indexPath.section), typedSection == .summary else { return }
    switch indexPath.row {
    case SummaryRows.settings.rawValue:
      // Settings
      let controller = AutoContributeSettingsViewController(ledger: ledger)
      navigationController?.pushViewController(controller, animated: true)
    case SummaryRows.monthlyPayment.rawValue:
      // Monthly payment
      guard let wallet = ledger.walletInfo else { break }
      let monthlyPayment = ledger.contributionAmount
      let choices = wallet.parametersChoices.map { $0.doubleValue }
      let selectedIndex = choices.index(of: monthlyPayment) ?? 0
      let stringChoices = choices.map { choice -> String in
        var amount = "\(choice) \(wallet.altcurrency)"
        if let dollarRate = ledger.dollarStringForBATAmount(choice) {
          amount.append(" (\(dollarRate))")
        }
        return amount
      }
      let controller = OptionsSelectionViewController(
        options: stringChoices,
        selectedOptionIndex: selectedIndex) { [weak self] (selectedIndex) in
          guard let self = self else { return }
          if selectedIndex < choices.count {
            self.ledger.contributionAmount = choices[selectedIndex]
          }
          self.navigationController?.popViewController(animated: true)
      }
      controller.title = Strings.AutoContributeMonthlyPayment
      navigationController?.pushViewController(controller, animated: true)
    case SummaryRows.excludedSites.rawValue:
      // FIXME: Use actual number
      let numberOfExcludedSites = 5
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: String(format: Strings.AutoContributeRestoreExcludedSites, numberOfExcludedSites), style: .default, handler: { _ in
        self.ledger.restoreAllExcludedPublishers()
        self.reloadData()
      }))
      alert.addAction(UIAlertAction(title: Strings.Cancel, style: .cancel, handler: nil))
      present(alert, animated: true)
    default:
      break
    }
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
      let isExcludingSites = true // FIXME: Change based on if user actually has excluded publishers
      return SummaryRows.numberOrRows(isExcludingSites)
    case .contributions:
      return upcomingContributions.isEmpty ? 1 : upcomingContributions.count
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    guard Section(rawValue: indexPath.section) == .contributions, !upcomingContributions.isEmpty else { return false }
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    guard Section(rawValue: indexPath.section) == .contributions, !upcomingContributions.isEmpty else { return .none }
    return .delete
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return Strings.Exclude
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard Section(rawValue: indexPath.section) == .contributions else { return }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      assertionFailure()
      return UITableViewCell()
    }
    switch section {
    case .summary:
      guard let row = SummaryRows(rawValue: indexPath.row) else { return UITableViewCell() }
      let cell = row.dequeuedCell(from: tableView, indexPath: indexPath)
      cell.manualSeparators = []
      cell.label.font = SettingsUX.bodyFont
      cell.label.textColor = .black
      cell.label.numberOfLines = 0
      cell.accessoryLabel?.textColor = Colors.grey100
      cell.accessoryLabel?.font = SettingsUX.bodyFont
      switch row {
      case .settings:
        cell.label.text = Strings.Settings
        cell.imageView?.image = UIImage(frameworkResourceNamed: "settings").alwaysTemplate
        cell.imageView?.tintColor = BraveUX.autoContributeTintColor
        cell.accessoryType = .disclosureIndicator
      case .monthlyPayment:
        cell.label.text = Strings.AutoContributeMonthlyPayment
        cell.accessoryType = .disclosureIndicator
        if let walletInfo = ledger.walletInfo, let dollarAmount = ledger.dollarStringForBATAmount(ledger.contributionAmount) {
          cell.accessoryLabel?.text = "\(ledger.contributionAmount) \(walletInfo.altcurrency) (\(dollarAmount))"
        }
      case .nextContribution:
        cell.label.text = Strings.AutoContributeNextDate
        cell.accessoryView = nextContributionDateView
        cell.selectionStyle = .none
      case .supportedSites:
        cell.label.text = Strings.AutoContributeSupportedSites
        cell.accessoryLabel?.attributedText = totalSitesAttributedString(from: upcomingContributions.count)
        cell.selectionStyle = .none
      case .excludedSites:
        // FIXME: Use actual number
        let numberOfExcludedSites = 5
        cell.label.text = String(format: Strings.AutoContributeRestoreExcludedSites, numberOfExcludedSites)
        cell.label.textColor = Colors.blurple400
      }
      return cell
    case .contributions:
      if upcomingContributions.isEmpty {
        let cell = tableView.dequeueReusableCell(for: indexPath) as EmptyTableCell
        cell.label.text = Strings.EmptyAutoContribution
        return cell
      }
      let contribution = upcomingContributions[indexPath.row]
      let cell = tableView.dequeueReusableCell(for: indexPath) as AutoContributeCell
      cell.selectionStyle = .none
      cell.siteImageView.image = UIImage(frameworkResourceNamed: "defaultFavicon")
      cell.verifiedStatusImageView.isHidden = !contribution.isVerified
      cell.siteNameLabel.text = contribution.site
      cell.attentionAmount = contribution.attention
      return cell
    }
  }
}

extension AutoContributeDetailViewController {
  class View: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      tableView.backgroundView = UIView().then {
        $0.backgroundColor = SettingsUX.backgroundColor
      }
      tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
      tableView.separatorInset = .zero
      tableView.register(AutoContributeCell.self)
      tableView.register(TableViewCell.self)
      tableView.register(Value1TableViewCell.self)
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
