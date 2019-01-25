/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletViewController.h"
#import "BATWalletHeaderView.h"

@interface BATWalletViewController ()
@property (nonatomic) BATWalletHeaderView *headerView;
@end

@implementation BATWalletViewController

- (instancetype)init
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.headerView = [[BATWalletHeaderView alloc] init]; {
      self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addSubview:self.headerView];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
  ]];
}

@end
