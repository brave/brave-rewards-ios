/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBasicAnimationController.h"

@interface BATBasicAnimationController ()
@property (nonatomic) BATAnimationDirection direction;
@property (nonatomic, weak) id<BATBasicAnimationControllerDelgate> delegate;
@end

@implementation BATBasicAnimationController

- (instancetype)initWithDirection:(BATAnimationDirection)direction delegate:(id<BATBasicAnimationControllerDelgate>)delegate
{
  if ((self = [super init])) {
    self.direction = direction;
    self.delegate = delegate;
  }
  return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
  return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  switch (self.direction) {
    case BATAnimationDirectionPresenting:
      [self.delegate animatePresentation:transitionContext];
      break;
    case BATAnimationDirectionDismissing:
      [self.delegate animateDismissal:transitionContext];
      break;
  }
}

@end
