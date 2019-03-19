/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

public class Button: UIButton {
  public var flipImageOrigin: Bool = false
  
  public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
    var frame = super.imageRect(forContentRect: contentRect)
    if flipImageOrigin {
      frame.origin.x = super.titleRect(forContentRect: contentRect).maxX - frame.width - imageEdgeInsets.right + imageEdgeInsets.left + titleEdgeInsets.right - titleEdgeInsets.left
    }
    return frame
  }
  
  public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    var frame = super.titleRect(forContentRect: contentRect)
    if flipImageOrigin {
      frame.origin.x -= imageRect(forContentRect: contentRect).width
    }
    return frame
  }
  
  public override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.width += abs(imageEdgeInsets.left) + abs(imageEdgeInsets.right) +
      abs(titleEdgeInsets.left) + abs(titleEdgeInsets.right)
    return size
  }
  
  var hitTestSlop: UIEdgeInsets = .zero
  
  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if bounds.inset(by: hitTestSlop).contains(point) {
      return true
    }
    return super.point(inside: point, with: event)
  }
}
