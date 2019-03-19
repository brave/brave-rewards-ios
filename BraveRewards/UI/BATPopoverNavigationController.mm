/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPopoverNavigationController.h"

@interface _BATNavigationBar : UINavigationBar
@end

@implementation _BATNavigationBar

- (CGRect)frame
{
  auto rect = [super frame];
  // safeAreaInsets.top is not always 8, for now just set it ourselves
  rect.origin.y = 8.0;
  return rect;
}

- (UIBarPosition)barPosition
{
  return UIBarPositionTopAttached;
}

@end

@implementation BATPopoverNavigationController

- (instancetype)init
{
  return [super initWithNavigationBarClass:[_BATNavigationBar class] toolbarClass:nil];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
  if ((self = [super initWithNavigationBarClass:[_BATNavigationBar class] toolbarClass:nil])) {
    self.viewControllers = @[rootViewController];
  }
  return self;
}

- (UIEdgeInsets)additionalSafeAreaInsets
{
  return UIEdgeInsetsMake(8, 0, 0, 0);
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  if (!self.navigationBarHidden) {
    auto navBarFrame = self.navigationBar.frame;
    navBarFrame.origin.y = self.additionalSafeAreaInsets.top;
    self.navigationBar.frame = navBarFrame;
  }
}


@end
