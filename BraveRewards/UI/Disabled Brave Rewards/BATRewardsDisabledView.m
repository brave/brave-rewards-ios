/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATRewardsDisabledView.h"
#import "BATRewardsDisabledContentView.h"
#import "BATGradientView.h"
#import "BATActionButton.h"

@interface BATRewardsDisabledView ()
@property (nonatomic) BATGradientView *gradientView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BATRewardsDisabledContentView *contentView;
@end

@implementation BATRewardsDisabledView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
      self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      self.scrollView.delaysContentTouches = NO;
    }
    
    self.gradientView = [BATGradientView softBlueToClearGradientView]; {
      self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.contentView = [[BATRewardsDisabledContentView alloc] init]; {
      self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.gradientView];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.widthAnchor],
      
      [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      
      [self.gradientView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.gradientView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [self.gradientView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.gradientView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      
      [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
      [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
    ]];
  }
  return self;
}

- (UIButton *)enableRewardsButton
{
  return (UIButton *)self.contentView.enableRewardsButton;
}

@end
