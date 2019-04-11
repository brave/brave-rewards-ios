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
      let cell = tableView.dequeueReusableCell(for: indexPath) as TipsSummaryTableCell
      cell.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
      // FIXME: Replace temp data
      cell.batValueView.amountLabel.text = "30.0"
      cell.usdValueView.amountLabel.text = "0.00"
      return cell
    case .tips:
      let cell = tableView.dequeueReusableCell(for: indexPath) as EmptyTableCell
      cell.label.text = BATLocalizedString("BraveRewardsEmptyTipsText", "Have you tipped your favourite content creator today?")
      return cell
    }
  }
}

extension TipsDetailViewController {
  class View: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      tableView.separatorStyle = .none
      tableView.register(TipsEntryTableCell.self)
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
