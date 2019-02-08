/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATAttentionView.h"

@interface BATAttentionView ()
@property (nonatomic) UILabel *titleLabel; // "Attention"
@property (nonatomic) UILabel *valueLabel; // "X%" / "–"
@end

@implementation BATAttentionView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.titleLabel = [[UILabel alloc] init]; {
//      self.titleLabel.textColor = [
    }
  }
  return self;
}

@end
