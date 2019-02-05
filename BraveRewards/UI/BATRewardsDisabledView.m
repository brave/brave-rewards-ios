/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATRewardsDisabledView.h"
#import "BATActionButton.h"

#import "NSBundle+Convenience.h"
#import "UIImage+Convenience.h"
#import "UIColor+RBG.h"

@interface BATRewardsDisabledView ()
@property (nonatomic) UIImageView *batLogoImageView;
@property (nonatomic) UILabel *titleLabel; // "Welcome back!"
@property (nonatomic) UILabel *subtitleLabel; // "Get rewarded for browsing."
@property (nonatomic) UILabel *bodyLabel; // "Earn by viewing privacy-respecting ads..."
@property (nonatomic) BATActionButton *enableRewardsButton;
@end

@implementation BATRewardsDisabledView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.batLogoImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"bat-logo"]]; {
      self.batLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.batLogoImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.font = [UIFont systemFontOfSize:28.0];
      self.titleLabel.textColor = UIColorFromRGB(75, 76, 92);
      self.titleLabel.textAlignment = NSTextAlignmentCenter;
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsDisabledTitle", @"Welcome back!", @"Title on wallet with disabled BR");
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.subtitleLabel = [[UILabel alloc] init]; {
      self.subtitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
      self.subtitleLabel.textColor = UIColorFromRGB(76, 84, 210);
      self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
      self.subtitleLabel.numberOfLines = 0;
      self.subtitleLabel.text = BATLocalizedString(@"BraveRewardsDisabledSubtitle", @"Get rewarded for browsing.", @"Subtitle on wallet with disabled BR");
      self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.bodyLabel = [[UILabel alloc] init]; {
      self.bodyLabel.font = [UIFont systemFontOfSize:16.0];
      self.bodyLabel.textColor = UIColorFromRGB(75, 76, 92);
      self.bodyLabel.textAlignment = NSTextAlignmentCenter;
      self.bodyLabel.numberOfLines = 0;
      self.bodyLabel.text = BATLocalizedString(@"BraveRewardsDisabledBody", @"Earn by viewing privacy-respecting ads, and pay it forward to support content creators you love.", @"Body on wallet with disabled BR");
      self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.enableRewardsButton = [BATActionButton buttonWithType:UIButtonTypeSystem]; {
      [self.enableRewardsButton setTitle:BATLocalizedString(@"BraveRewardsDisabledEnableButton", @"Enable Brave Rewards", @"Enable brave rewards button title").uppercaseString forState:UIControlStateNormal];
      [self.enableRewardsButton setImage:[UIImage bat_imageNamed:@"continue-button-arrow"].bat_original forState:UIControlStateNormal];
      self.enableRewardsButton.titleLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
      self.enableRewardsButton.tintColor = UIColorFromRGB(76, 84, 210);
      self.enableRewardsButton.flipImageOrigin = YES;
      self.enableRewardsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
      self.enableRewardsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
      self.enableRewardsButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.batLogoImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.bodyLabel];
    [self addSubview:self.enableRewardsButton];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.batLogoImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:15.0],
      [self.batLogoImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.batLogoImageView.bottomAnchor constant:10.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5.0],
      [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.bodyLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:10.0],
      [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40.0],
      [self.bodyLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40.0],
      
      [self.enableRewardsButton.topAnchor constraintGreaterThanOrEqualToAnchor:self.bodyLabel.bottomAnchor constant:30.0],
      [self.enableRewardsButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40.0],
      [self.enableRewardsButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40.0],
      [self.enableRewardsButton.heightAnchor constraintEqualToConstant:40.0],
      [self.enableRewardsButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-25.0],
    ]];
  }
  return self;
}

@end
