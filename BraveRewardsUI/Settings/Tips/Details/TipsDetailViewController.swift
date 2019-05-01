/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import BraveRewards

class TipsDetailViewController: UIViewController {
  
  private var tipsView: View {
    return view as! View
  }
  
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
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tappedEditButton))
    
    tipsView.tableView.delegate = self
    tipsView.tableView.dataSource = self

    title = BATLocalizedString("BraveRewardsTips", "Tips")
  }
  
  private let headerView = TableHeaderRowView(
    columns: [
      TableHeaderRowView.Column(
        title: BATLocalizedString("BraveRewardsSite", "Site").uppercased(),
        width: .percentage(0.7)
      ),
      TableHeaderRowView.Column(
        title: BATLocalizedString("BraveRewardsTokens", "Tokens").uppercased(),
        width: .percentage(0.3),
        align: .right
      ),
    ],
    tintColor: BraveUX.tipsTintColor
  )
  
  // MARK: - Actions
  
  @objc private func tappedEditButton() {
    tipsView.tableView.setEditing(true, animated: true)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
  }
  
  @objc private func tappedDoneButton() {
    tipsView.tableView.setEditing(false, animated: true)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tappedEditButton))
  }
}

extension TipsDetailViewController: UITableViewDataSource, UITableViewDelegate {
  private enum Section: Int, CaseIterable {
    case summary
    case tips
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let typedSection = Section(rawValue: section), typedSection == .tips else { return nil }
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let typedSection = Section(rawValue: section), typedSection == .tips else { return 0.0 }
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
      return 1
    case .tips:
//      return 1
      return 3
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      assertionFailure()
      return UITableViewCell()
    }
    switch section {
    case .summary:
      let cell = tableView.dequeueReusableCell(for: indexPath) as TipsSummaryTableCell
      cell.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
      // FIXME: Replace temp data
      cell.batValueView.amountLabel.text = "30.0"
      cell.usdValueView.amountLabel.text = "0.00"
      return cell
    case .tips:
//      let cell = tableView.dequeueReusableCell(for: indexPath) as EmptyTableCell
//      cell.label.text = BATLocalizedString("BraveRewardsEmptyTipsText", "Have you tipped your favourite content creator today?")
//      return cell
      let cell = tableView.dequeueReusableCell(for: indexPath) as TipsTableCell
      cell.siteNameLabel.text = "theguardian.com"
      cell.siteImageView.image = UIImage(frameworkResourceNamed: "defaultFavicon")
      cell.verifiedStatusImageView.isHidden = indexPath.row != 0
      cell.typeNameLabel.text = "Recurring"
      cell.selectionStyle = .none
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    guard Section(rawValue: indexPath.section) == .tips else { return false }
    // TODO: Only return true for recurring tips
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    guard Section(rawValue: indexPath.section) == .tips else { return .none }
    return .delete
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return BATLocalizedString("BraveRewardsRemove", "Remove")
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard Section(rawValue: indexPath.section) == .tips else { return }
    
  }
}

extension TipsDetailViewController {
  class View: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      tableView.backgroundView = UIView().then {
        $0.backgroundColor = SettingsUX.backgroundColor
      }
      tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
      tableView.separatorInset = .zero
      tableView.register(TipsTableCell.self)
      tableView.register(TipsSummaryTableCell.self)
      tableView.register(EmptyTableCell.self)
      
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
