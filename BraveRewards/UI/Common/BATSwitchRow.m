/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATSwitchRow.h"
#import "UIColor+BATColors.h"

@interface BATSwitchRow ()
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UISwitch *toggleSwitch;
@end

@implementation BATSwitchRow

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.textLabel = [[UILabel alloc] init]; {
      self.textLabel.font = [UIFont systemFontOfSize:14.0];
      self.textLabel.textColor = [UIColor bat_grey200];
      self.textLabel.numberOfLines = 0;
      self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.toggleSwitch = [[UISwitch alloc] init]; {
      self.toggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;
      [self.toggleSwitch setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    [self addArrangedSubview:self.textLabel];
    [self addArrangedSubview:self.toggleSwitch];
  }
  return self;
}

@end
