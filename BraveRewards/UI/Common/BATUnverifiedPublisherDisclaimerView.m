/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATUnverifiedPublisherDisclaimerView.h"
#import "NSBundle+Convenience.h"
#import "UIColor+RGB.h"

@interface BATUnverifiedPublisherDisclaimerView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation BATUnverifiedPublisherDisclaimerView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.textView = [[UITextView alloc] init]; {
      self.textView.translatesAutoresizingMaskIntoConstraints = NO;
      self.textView.editable = NO;
      self.textView.scrollEnabled = NO;
      self.textView.delegate = self;
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.04];
    
    // There are 3 pieces to the text in the text view.
    // - general disclaimer
    // - "Learn More"
    // - "change Auto-Contribute setting"
    
    self.textView.attributedText = ^NSAttributedString *{
      __auto_type text = [[NSMutableAttributedString alloc] init];
      
      __auto_type disclaimerText = BATLocalizedString(@"BraveRewardsUnverifiedPublisherDisclaimer", @"This creator has not yet signed up to receive contributions from Brave users. Any tips you send will remain in your wallet until they verify.", nil);
      __auto_type disclaimerAttrText = [[NSAttributedString alloc] initWithString:disclaimerText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: UIColorFromRGB(103, 100, 128) }];
      
      __auto_type learnMoreText = BATLocalizedString(@"BraveRewardsUnverifiedPublisherDisclaimerLearnMore", @"Learn More", nil);
      __auto_type learnMoreAttrText = [[NSAttributedString alloc] initWithString:learnMoreText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: UIColorFromRGB(0, 137, 255), NSLinkAttributeName: @"learn-more" }];
      
      [text appendAttributedString:disclaimerAttrText];
      [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
      [text appendAttributedString:learnMoreAttrText];
      
      return [text copy];
    }();
    
    [self addSubview:self.textView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.textView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0],
      [self.textView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:8.0],
      [self.textView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-8.0],
      [self.textView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0],
    ]];
  }
  return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
  NSLog(@"%@", URL);
  if (self.tappedLearnMore) {
    self.tappedLearnMore();
  }
  return YES;
}

@end
