/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATActionButton.h"

@implementation BATActionButton

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1.0;
    
    // Default
    self.tintColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
  [super setTintColor:tintColor];
  
  [self setTitleColor:tintColor forState:UIControlStateNormal];
  self.layer.borderColor = [tintColor colorWithAlphaComponent:0.5].CGColor;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.layer.cornerRadius = self.bounds.size.height / 2.0;
}

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
