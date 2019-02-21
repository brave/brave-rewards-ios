/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATTippingOverviewView.h"
#import "UIColor+BATColors.h"
#import "UIImage+Convenience.h"
#import "NSBundle+Convenience.h"

static const CGSize kFaviconSize = (CGSize){ .width = 88.0, .height = 88.0 };

@interface BATTippingOverviewView ()
@property (nonatomic) UIImageView *headerView;
@property (nonatomic) UIImageView *watermarkImageView;
@property (nonatomic) UIImageView *heartsImageView;
@property (nonatomic) UIImageView *faviconImageView;
@property (nonatomic) UIStackView *socialStackView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *bodyLabel;
@end

@implementation BATTippingOverviewView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor bat_blurple800];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4.0;
    
    self.headerView = [[UIImageView alloc] init]; {
      self.headerView.backgroundColor = [UIColor bat_grey300];
      self.headerView.clipsToBounds = YES;
      self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.watermarkImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"tipping-bat-watermark"]]; {
      self.watermarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.heartsImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"hearts"]]; {
      self.heartsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.socialStackView = [[UIStackView alloc] init]; {
      self.socialStackView.spacing = 20.0;
      for (NSString *socialIcon in @[ @"pub-youtube", @"pub-twitter", @"pub-twitch" ]) {
        [self.socialStackView addArrangedSubview:[[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:socialIcon]]];
      }
      self.socialStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.faviconImageView = [[UIImageView alloc] init]; {
      self.faviconImageView.backgroundColor = [UIColor bat_neutral800];
      self.faviconImageView.clipsToBounds = YES;
      self.faviconImageView.layer.cornerRadius = kFaviconSize.width / 2.0;
      self.faviconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
      self.faviconImageView.layer.borderWidth = 2.0;
      self.faviconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsTippingOverviewTitle", @"Thanks for stopping by!");
      self.titleLabel.font = [UIFont systemFontOfSize:23.0 weight:UIFontWeightSemibold];
      self.titleLabel.textColor = [UIColor bat_grey100];
      self.titleLabel.numberOfLines = 0;
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.bodyLabel = [[UILabel alloc] init]; {
      self.bodyLabel.text = BATLocalizedString(@"BraveRewardsTippingOverviewBody", @"You can support this site by sending a tip. It’s a way of thanking them for making great content. Verified content creators get paid for their tips during the first week of each calendar month.\n\nIf you like, you can schedule monthly tips to support this site on a continuous basis.");
      self.bodyLabel.font = [UIFont systemFontOfSize:17.0];
      self.bodyLabel.textColor = [UIColor bat_grey200];
      self.bodyLabel.numberOfLines = 0;
      self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.watermarkImageView];
//    [self.headerView addSubview:self.heartsImageView];
    [self addSubview:self.socialStackView];
    [self addSubview:self.faviconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.bodyLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.headerView.heightAnchor constraintEqualToConstant:98.0],
      
      [self.watermarkImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
      [self.watermarkImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
      
//      [self.heartsImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
//      [self.heartsImageView.leadingAnchor constraintEqualToAnchor:self.watermarkImageView.trailingAnchor constant:40.0],
//      [self.heartsImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
      
//      [self.faviconImageView.centerYAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:-10.0],
      [self.faviconImageView.bottomAnchor constraintEqualToAnchor:self.socialStackView.bottomAnchor],
      [self.faviconImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25.0],
      [self.faviconImageView.widthAnchor constraintEqualToConstant:kFaviconSize.width],
      [self.faviconImageView.heightAnchor constraintEqualToConstant:kFaviconSize.height],
      
      [self.socialStackView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:20.0],
      [self.socialStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.faviconImageView.bottomAnchor constant:25.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25.0],
      [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25.0],
      
      [self.bodyLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10.0],
      [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
      [self.bodyLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
      [self.bodyLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-25.0]
    ]];
  }
  return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
  [super traitCollectionDidChange:previousTraitCollection];
  [self setNeedsUpdateConstraints];
}

@end
