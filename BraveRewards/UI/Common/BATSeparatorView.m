/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATSeparatorView.h"
#import "UIColor+BATColors.h"

@implementation BATSeparatorView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor bat_neutral600];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightAnchor constraintEqualToConstant:1.0 / UIScreen.mainScreen.scale].active = YES;
  }
  return self;
}

@end
