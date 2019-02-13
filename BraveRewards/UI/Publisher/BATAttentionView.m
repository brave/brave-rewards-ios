/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATAttentionView.h"
#import "UIColor+BATColors.h"
#import "NSBundle+Convenience.h"

@interface BATAttentionView ()
@property (nonatomic) UILabel *titleLabel; // "Attention"
@property (nonatomic) UILabel *valueLabel; // "X%" / "–"
@end

@implementation BATAttentionView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.textColor = [UIColor bat_darkTextColor];
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsAttention", @"Attention");
      self.titleLabel.font = [UIFont systemFontOfSize:14.0];
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.valueLabel = [[UILabel alloc] init]; {
      self.valueLabel.textColor = [UIColor bat_darkTextColor];
      self.valueLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
      self.valueLabel.textAlignment = NSTextAlignmentRight;
      self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
      [self.valueLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    UILayoutGuide *paddingGuide = [[UILayoutGuide alloc] init];
    [self addLayoutGuide:paddingGuide];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [paddingGuide.topAnchor constraintEqualToAnchor:self.topAnchor constant:0],
      [paddingGuide.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [paddingGuide.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [paddingGuide.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-0],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:paddingGuide.topAnchor],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:paddingGuide.leadingAnchor],
      [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.valueLabel.leadingAnchor constant:-10.0],
      [self.titleLabel.bottomAnchor constraintEqualToAnchor:paddingGuide.bottomAnchor],
      
      [self.valueLabel.topAnchor constraintEqualToAnchor:self.titleLabel.topAnchor],
      [self.valueLabel.trailingAnchor constraintEqualToAnchor:paddingGuide.trailingAnchor],
      [self.valueLabel.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
    ]];
  }
  return self;
}

@end
