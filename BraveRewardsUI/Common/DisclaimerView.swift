/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class DisclaimerView: UIView {
  
  private struct UX {
    static let textColor = Colors.grey200
    static let linkColor = Colors.blue500
  }
  
  var text: String {
    didSet {
      updateText()
    }
  }
  
  var tappedLearnMore: (() -> Void)?
  
  private lazy var textView = UITextView().then {
    $0.delaysContentTouches = false
    $0.isEditable = false
    $0.isScrollEnabled = false
    $0.delegate = self
    $0.backgroundColor = .clear
    $0.textDragInteraction?.isEnabled = false
    $0.textContainerInset = .zero
  }
  
  public init(text: String) {
    self.text = text
    
    super.init(frame: .zero)
    
    backgroundColor = UIColor(white: 0.0, alpha: 0.04)
    layer.cornerRadius = 4.0
    
    addSubview(textView)
    
    textView.snp.makeConstraints {
      $0.edges.equalTo(self).inset(8.0)
    }
    
    updateText()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: -
  
  private func updateText() {
    let disclaimerText = NSAttributedString(
      string: self.text,
      attributes: [
        .font: UIFont.systemFont(ofSize: 12.0),
        .foregroundColor: UX.textColor,
      ]
    )
    
    let learnMoreText = NSAttributedString(
      string: BATLocalizedString("BraveRewardsDisclaimerLearnMore", "Learn More"),
      attributes: [
        .font: UIFont.systemFont(ofSize: 12.0),
        .foregroundColor: UX.linkColor,
        .link: "learn-more"
      ]
    )
    
    let text = NSMutableAttributedString()
    text.append(disclaimerText)
    text.append(NSAttributedString(string: " "))
    text.append(learnMoreText)
    textView.attributedText = text
  }
}

extension DisclaimerView: UITextViewDelegate {
  public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    self.tappedLearnMore?()
    return false
  }
}
