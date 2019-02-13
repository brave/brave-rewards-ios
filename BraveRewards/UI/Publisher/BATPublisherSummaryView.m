/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPublisherSummaryView.h"
#import "BATSeparatorView.h"
#import "BATActionButton.h"
#import "NSBundle+Convenience.h"
#import "BATSwitchRow.h"

@interface BATPublisherSummaryView ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) BATPublisherView *publisherView;
@property (nonatomic) BATAttentionView *attentionView;
@property (nonatomic) BATActionButton *tipButton;
@end

@implementation BATPublisherSummaryView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
      self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      self.scrollView.delaysContentTouches = NO;
    }
    
    self.stackView = [[UIStackView alloc] init]; {
      self.stackView.spacing = 8.0;
      self.stackView.axis = UILayoutConstraintAxisVertical;
      self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.publisherView = [[BATPublisherView alloc] init]; {
      self.publisherView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.attentionView = [[BATAttentionView alloc] init]; {
      self.attentionView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.tipButton = [BATActionButton buttonWithType:UIButtonTypeSystem]; {
      self.tipButton.tintColor = [UIColor blueColor];
      [self.tipButton setTitle:BATLocalizedString(@"BraveRewardsPublisherSendTip", @"Send a tip").uppercaseString forState:UIControlStateNormal];
      self.tipButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.stackView];
    
    [self.stackView addArrangedSubview:self.publisherView];
    [self.stackView setCustomSpacing:20.0 afterView:self.publisherView];
    [self.stackView addArrangedSubview:self.attentionView];
    [self.stackView addArrangedSubview:[[BATSeparatorView alloc] init]];
    BATSwitchRow *switchRow = [[BATSwitchRow alloc] init]; {
      switchRow.textLabel.text = @"Auto-Contribute";
    }
    [self.stackView addArrangedSubview:switchRow];
    BATSeparatorView *finalSeparator = [[BATSeparatorView alloc] init];
    [self.stackView addArrangedSubview:finalSeparator];
    [self.stackView setCustomSpacing:20.0 afterView:finalSeparator];
    [self.stackView addArrangedSubview:self.tipButton];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.widthAnchor],
      
      [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:20.0],
      [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30.0],
      [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-30.0],
      [self.scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:20.0],
      
      [self.tipButton.heightAnchor constraintEqualToConstant:40.0],
    ]];
  }
  return self;
}

- (BOOL)displayRewardsSummaryButton
{
  return YES;
}

@end
