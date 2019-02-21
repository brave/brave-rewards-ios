/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATSendTipButton.h"
#import "UIColor+BATColors.h"
#import "UIImage+Convenience.h"
#import "NSBundle+Convenience.h"

@interface BATSendTipButton ()
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *textLabel;
@end

@implementation BATSendTipButton

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor bat_blurple400];
    
    self.stackView = [[UIStackView alloc] init]; {
      self.stackView.spacing = 15.0;
      self.stackView.userInteractionEnabled = NO;
      self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"airplane-icn"].bat_template]; {
      self.imageView.tintColor = [UIColor bat_blurple600];
      self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.textLabel = [[UILabel alloc] init]; {
      self.textLabel.textColor = [UIColor whiteColor];
      self.textLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
      self.textLabel.text = BATLocalizedString(@"BraveRewardsTippingSendTip", @"Send my tip").uppercaseString;
      self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.imageView];
    [self.stackView addArrangedSubview:self.textLabel];
    
    UILayoutGuide *contentGuide = [[UILayoutGuide alloc] init];
    [self addLayoutGuide:contentGuide];
    
    [NSLayoutConstraint activateConstraints:@[
      [contentGuide.topAnchor constraintEqualToAnchor:self.topAnchor],
      [contentGuide.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [contentGuide.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [contentGuide.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor],
      [contentGuide.heightAnchor constraintEqualToConstant:56.0],
      
      [self.stackView.centerXAnchor constraintEqualToAnchor:contentGuide.centerXAnchor],
      [self.stackView.centerYAnchor constraintEqualToAnchor:contentGuide.centerYAnchor],
      [self.stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:contentGuide.leadingAnchor],
      [self.stackView.trailingAnchor constraintLessThanOrEqualToAnchor:contentGuide.trailingAnchor],
    ]];
  }
  return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  
  [UIView animateWithDuration:self.highlighted ? 0.05 : 0.4 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    self.textLabel.alpha = self.highlighted ? 0.3 : 1.0;
    self.imageView.alpha = self.highlighted ? 0.3 : 1.0;
  } completion:nil];
}

@end
