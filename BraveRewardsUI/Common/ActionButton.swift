/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

public class ActionButton: Button {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel?.font = .boldSystemFont(ofSize: 14.0)
    backgroundColor = .clear
    layer.borderWidth = 1.0
    tintColor = .white
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
   
    layer.cornerRadius = bounds.height / 2.0
  }
  
  public override var tintColor: UIColor! {
    didSet {
      setTitleColor(tintColor, for: .normal)
      layer.borderColor = tintColor.withAlphaComponent(0.5).cgColor
    }
  }
}
