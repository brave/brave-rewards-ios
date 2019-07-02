// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class PublisherIconCircleImageView: UIImageView {
  
  init(size: CGFloat) {
    super.init(frame: .zero)
    
    snp.makeConstraints {
      $0.size.equalTo(size)
    }
    
    setContentHuggingPriority(.required, for: .horizontal)
    
    contentMode = .scaleAspectFill
    clipsToBounds = true
    image = UIImage(frameworkResourceNamed: "defaultFavicon")
    
    layer.do {
      $0.cornerRadius = size / 2.0
      $0.borderColor = Colors.neutral800.cgColor
      $0.borderWidth = 1.0 / UIScreen.main.scale
    }
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
}
