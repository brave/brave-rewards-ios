/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATDisclaimerView.h"
#import "NSBundle+Convenience.h"
#import "UIColor+RGB.h"

@interface BATDisclaimerView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation BATDisclaimerView

- (instancetype)initWithText:(NSString *)text
{
  if ((self = [super initWithFrame:CGRectZero])) {
    self.textView = [[UITextView alloc] init]; {
      self.textView.translatesAutoresizingMaskIntoConstraints = NO;
      self.textView.editable = NO;
      self.textView.scrollEnabled = NO;
      self.textView.delegate = self;
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.04];
    
    [self addSubview:self.textView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.textView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0],
      [self.textView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0],
      [self.textView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0],
      [self.textView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0],
    ]];
    
    self.text = text;
  }
  return self;
}

- (void)setText:(NSString *)text
{
  _text = [text copy];
  
  // There are 2 pieces to the text in the text view.
  // - general disclaimer
  // - "Learn More"
  
  self.textView.attributedText = ^NSAttributedString *{
    __auto_type text = [[NSMutableAttributedString alloc] init];
    
    __auto_type disclaimerText = self.text;
    __auto_type disclaimerAttrText = [[NSAttributedString alloc] initWithString:disclaimerText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: UIColorFromRGB(103, 100, 128) }];
    
    __auto_type learnMoreText = BATLocalizedString(@"BraveRewardsUnverifiedPublisherDisclaimerLearnMore", @"Learn More", nil);
    __auto_type learnMoreAttrText = [[NSAttributedString alloc] initWithString:learnMoreText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: UIColorFromRGB(0, 137, 255), NSLinkAttributeName: @"learn-more" }];
    
    [text appendAttributedString:disclaimerAttrText];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [text appendAttributedString:learnMoreAttrText];
    
    return [text copy];
  }();
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
