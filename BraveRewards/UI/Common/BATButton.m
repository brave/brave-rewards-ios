/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATButton.h"

@implementation BATButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super imageRectForContentRect:contentRect];
  if (self.flipImageOrigin) {
    frame.origin.x = CGRectGetMaxX([super titleRectForContentRect:contentRect]) - frame.size.width - self.imageEdgeInsets.right + self.imageEdgeInsets.left + self.titleEdgeInsets.right - self.titleEdgeInsets.left;
  }
  return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super titleRectForContentRect:contentRect];
  if (self.flipImageOrigin) {
    frame.origin.x -= [self imageRectForContentRect:contentRect].size.width;
  }
  return frame;
}

- (CGSize)intrinsicContentSize
{
  // Take edge insets into account when computing size
  CGSize size = [super intrinsicContentSize];
  size.width += fabs(self.imageEdgeInsets.left) + fabs(self.imageEdgeInsets.right) +
  fabs(self.titleEdgeInsets.left) + fabs(self.titleEdgeInsets.right);
  return size;
}

@end
