/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class SendTipButton: UIControl {
  
  let stackView = UIStackView().then {
    $0.spacing = 15.0
    $0.isUserInteractionEnabled = false
  }
  
  let imageView = UIImageView(image: UIImage(frameworkResourceNamed: "airplane-icn").alwaysTemplate).then {
    $0.tintColor = Colors.blurple600
  }
  
  let textLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 13.0, weight: .semibold)
    $0.text = BATLocalizedString("BraveRewardsTippingSendTip", "Send my tip".uppercased())
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = Colors.blurple400
    
    addSubview(stackView)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(textLabel)
    
    let contentGuide = UILayoutGuide()
    addLayoutGuide(contentGuide)
    
    contentGuide.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.height.equalTo(56.0)
    }
    stackView.snp.makeConstraints {
      $0.center.equalTo(contentGuide)
      $0.leading.greaterThanOrEqualTo(contentGuide)
      $0.trailing.lessThanOrEqualTo(contentGuide)
    }
  }
  
  // MARK: -
  
  public override var isHighlighted: Bool {
    didSet {
      // Replicating usual UIButton highlight animation
      UIView.animate(withDuration: isHighlighted ? 0.05 : 0.4, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
        self.textLabel.alpha = self.isHighlighted ? 0.3 : 1.0
        self.imageView.alpha = self.isHighlighted ? 0.3 : 1.0
      }, completion: nil)
    }
  }
}
