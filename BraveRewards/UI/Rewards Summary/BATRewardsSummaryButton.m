/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATRewardsSummaryButton.h"
#import "NSBundle+Convenience.h"
#import "UIImage+Convenience.h"
#import "UIColor+BATColors.h"

@interface BATRewardsSummaryButton ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *slideToggleImageView;
@end

@implementation BATRewardsSummaryButton

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor bat_rewardsSummaryButtonColor];
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsSummaryTitle", @"Rewards Summary").uppercaseString;
      self.titleLabel.textColor = [UIColor bat_rewardsSummaryTextColor];
      self.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.slideToggleImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"slide-up"]]; {
      [self.slideToggleImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
      self.slideToggleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    UILayoutGuide *paddingGuide = [[UILayoutGuide alloc] init];
    [self addLayoutGuide:paddingGuide];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.slideToggleImageView];
    
    [NSLayoutConstraint activateConstraints:@[
      [paddingGuide.topAnchor constraintEqualToAnchor:self.topAnchor constant:15.0],
      [paddingGuide.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:22.0],
      [paddingGuide.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-22.0],
      [paddingGuide.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-15.0],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:paddingGuide.topAnchor],
      [self.titleLabel.bottomAnchor constraintEqualToAnchor:paddingGuide.bottomAnchor],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:paddingGuide.leadingAnchor],
      [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.slideToggleImageView.leadingAnchor constant:-20.0],
      
      [self.slideToggleImageView.centerYAnchor constraintEqualToAnchor:paddingGuide.centerYAnchor],
      [self.slideToggleImageView.trailingAnchor constraintEqualToAnchor:paddingGuide.trailingAnchor]
    ]];
  }
  return self;
}

@end
