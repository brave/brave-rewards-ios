/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATRewardsSummaryRow.h"
#import "UIColor+BATColors.h"
#import "UIColor+RGB.h"

@interface BATRewardsSummaryRow ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *cryptoCurrencyLabel;
@property (nonatomic) UILabel *cryptoValueLabel;
@property (nonatomic) UILabel *dollarValueLabel;
@end

@implementation BATRewardsSummaryRow

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.textColor = [UIColor bat_darkTextColor];
      self.titleLabel.font = [UIFont systemFontOfSize:14.0];
      self.titleLabel.numberOfLines = 0;
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.cryptoValueLabel = [[UILabel alloc] init]; {
      self.cryptoValueLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
      self.cryptoValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.cryptoCurrencyLabel = [[UILabel alloc] init]; {
      self.cryptoCurrencyLabel.textColor = UIColorFromRGB(104, 105, 120);
      self.cryptoCurrencyLabel.font = [UIFont systemFontOfSize:12.0];
      self.cryptoCurrencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.dollarValueLabel = [[UILabel alloc] init]; {
      self.dollarValueLabel.textColor = UIColorFromRGB(131, 131, 145);
      self.dollarValueLabel.font = [UIFont systemFontOfSize:10.0];
      self.dollarValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
      [self.dollarValueLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    UILayoutGuide *paddingGuide = [[UILayoutGuide alloc] init];
    [self addLayoutGuide:paddingGuide];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.cryptoValueLabel];
    [self addSubview:self.cryptoCurrencyLabel];
    [self addSubview:self.dollarValueLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [paddingGuide.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0],
      [paddingGuide.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [paddingGuide.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [paddingGuide.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10.0],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:paddingGuide.topAnchor],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:paddingGuide.leadingAnchor],
      [self.titleLabel.bottomAnchor constraintEqualToAnchor:paddingGuide.bottomAnchor],
      [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.cryptoValueLabel.leadingAnchor constant:-8.0],
      
      [self.cryptoValueLabel.firstBaselineAnchor constraintEqualToAnchor:self.titleLabel.firstBaselineAnchor],
      [self.cryptoValueLabel.trailingAnchor constraintEqualToAnchor:self.cryptoCurrencyLabel.leadingAnchor constant:2.0],
      
      [self.cryptoCurrencyLabel.firstBaselineAnchor constraintEqualToAnchor:self.cryptoValueLabel.firstBaselineAnchor],
      [self.cryptoCurrencyLabel.trailingAnchor constraintEqualToAnchor:self.dollarValueLabel.leadingAnchor constant:8.0],
      
      [self.dollarValueLabel.firstBaselineAnchor constraintLessThanOrEqualToAnchor:self.cryptoValueLabel.firstBaselineAnchor],
      [self.dollarValueLabel.trailingAnchor constraintLessThanOrEqualToAnchor:paddingGuide.trailingAnchor],
      [self.dollarValueLabel.widthAnchor constraintGreaterThanOrEqualToConstant:60.0],
    ]];
  }
  return self;
}

@end
