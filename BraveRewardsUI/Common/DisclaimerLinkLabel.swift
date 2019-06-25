// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

/// A Disclaimer Label that allows clickable links (or data-detectors)
final class DisclaimerLinkLabel: UITextView {
  
  /// Called when a link is tapped
  var onLinkedTapped: ((Link) -> Void)?
  
  /// Types of links supported by this label
  public enum Link {
    case unknown
    case termsOfService
    case privacyPolicy
  }
  
  override var text: String? {
    didSet {
      updateText()
    }
  }
  
  /// Converts the text into attributed text for display
  func updateText() {
    guard let text = text else {
      super.text = nil
      return
    }
    
    let attributedString = { () -> NSAttributedString? in
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      let attributes: [NSAttributedString.Key: Any] = [.font: self.font ?? UIFont.systemFont(ofSize: 12.0),
                                                       .foregroundColor: self.textColor ?? UX.textColor,
                                                       .paragraphStyle: paragraphStyle]
      
      let text = try? NSMutableAttributedString(data: text.data(using: .utf8) ?? Data(),
                                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                    .defaultAttributes: attributes],
                                                          documentAttributes: nil)
      
      let range = NSRange(location: 0, length: text?.length ?? 0)
      text?.addAttribute(.foregroundColor, value: self.textColor ?? UX.textColor, range: range)
      text?.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
      
      text?.beginEditing()
      text?.enumerateAttribute(.underlineStyle, in: range, options: .init(rawValue: 0), using: { value, range, stop in
        if value != nil {
          text?.addAttribute(.underlineStyle, value: 0, range: range)
        }
      })
      text?.endEditing()
      return text
    }
    
    let linkAttributes: [NSAttributedString.Key: Any] = [
      .font: self.font ?? UIFont.systemFont(ofSize: 12.0),
      .foregroundColor: UX.linkColor,
      .underlineStyle: 0
    ]
    
    self.linkTextAttributes = linkAttributes
    self.attributedText = attributedString()
    
    setAccessibility()
  }
  
  /// Makes this label accessible as static text.
  private func setAccessibility() {
    accessibilityLabel = self.text
    accessibilityTraits = .staticText
    accessibilityValue = nil
    isAccessibilityElement = true
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
    super.init(frame: frame, textContainer: textContainer)
    
    /// Setup
    textAlignment = .center
    delaysContentTouches = false
    isEditable = false
    isScrollEnabled = false
    isSelectable = true
    backgroundColor = .clear
    textDragInteraction?.isEnabled = false
    textContainerInset = .zero
    delegate = self
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private struct UX {
    static let textColor = Colors.grey900
    static let linkColor = Colors.blue500
  }
}

extension DisclaimerLinkLabel: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    /// Handle when links are tapped on
    switch URL.path {
    case "/terms":
      onLinkedTapped?(.termsOfService)
      
    case "/policy":
      onLinkedTapped?(.privacyPolicy)
      
    default:
      onLinkedTapped?(.unknown)
    }
    return false
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    /// Detect if we're tapping on a link.. otherwise make everything else NOT selectable.
    /// This also fixes a bug where you tap on the "side" of a link and it still triggers.
    guard let pos = closestPosition(to: point) else { return false }
    guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }
    let startIndex = offset(from: beginningOfDocument, to: range.start)
    return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
  }
}
