/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATRewardsSummaryView.h"
#import "BATSeparatorView.h"
#import "BATGradientView.h"
#import "UIColor+BATColors.h"

@interface BATRewardsSummaryView ()
@property (nonatomic) BATRewardsSummaryButton *rewardsSummaryButton;
@property (nonatomic) UILabel *monthYearLabel;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BATGradientView *gradientView;
@property (nonatomic) UIStackView *stackView;
@end

@implementation BATRewardsSummaryView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.rewardsSummaryButton = [[BATRewardsSummaryButton alloc] init]; {
      self.rewardsSummaryButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.gradientView = [[BATGradientView alloc] init]; {
      self.gradientView.gradientLayer.colors = @[ (id)[UIColor bat_blurple800].CGColor,
                                                  (id)[UIColor whiteColor].CGColor,
                                                  (id)[UIColor whiteColor].CGColor ];
      self.gradientView.gradientLayer.locations = @[ @0.0, @0.430, @1.0 ];
    }
    
    self.monthYearLabel = [[UILabel alloc] init]; {
      self.monthYearLabel.textColor = [UIColor bat_blurple400];
      self.monthYearLabel.font = [UIFont systemFontOfSize:22.0];
      self.monthYearLabel.alpha = 0.0; // hidden by default
      self.monthYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.stackView = [[UIStackView alloc] init]; {
      self.stackView.axis = UILayoutConstraintAxisVertical;
      self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.gradientView];
    [self addSubview:self.rewardsSummaryButton];
    [self addSubview:self.monthYearLabel];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.stackView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.rewardsSummaryButton.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.rewardsSummaryButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.rewardsSummaryButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.rewardsSummaryButton.heightAnchor constraintEqualToConstant:48.0],
      
      [self.monthYearLabel.topAnchor constraintEqualToAnchor:self.rewardsSummaryButton.titleLabel.bottomAnchor constant:4.0],
      [self.monthYearLabel.leadingAnchor constraintEqualToAnchor:self.rewardsSummaryButton.titleLabel.leadingAnchor],
      [self.monthYearLabel.trailingAnchor constraintEqualToAnchor:self.rewardsSummaryButton.slideToggleImageView.trailingAnchor],
      
      [self.scrollView.topAnchor constraintEqualToAnchor:self.monthYearLabel.bottomAnchor constant:20.0],
      [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.widthAnchor],
      
      [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
      [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:22.0],
      [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-22.0],
      [self.scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor],
    ]];
  }
  return self;
}

- (void)setRows:(NSArray<BATRewardsSummaryRow *> *)rows
{
  if (self.rows.count > 0) {
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  }
  
  _rows = [rows copy];
  
  for (BATRewardsSummaryRow *row in rows) {
    [self.stackView addArrangedSubview:row];
    if (row != rows.lastObject) {
      [self.stackView addArrangedSubview:[[BATSeparatorView alloc] init]];
    }
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  [self.scrollView layoutIfNeeded];
  self.gradientView.frame = self.scrollView.frame;
}

@end
