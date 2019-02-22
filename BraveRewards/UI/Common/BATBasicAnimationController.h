/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BATBasicAnimationControllerDelgate
@required

/// Animate the presentation of a controller
///
/// - parameter context: The transitioning context
- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)context;

/// Animate the dismissal of a controller
///
/// - parameter context: The transitioning context
- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)context;

@end

/// The animation direction
typedef NS_ENUM(NSUInteger, BATAnimationDirection) {
  /// The controller is being presented
  BATAnimationDirectionPresenting,
  /// The controller is being dismissed
  BATAnimationDirectionDismissing
};

/// Defines an animation controller which simply redirects presentation/dismissal animations to its delegate.
///
/// This allows us to create complex animations within the controller which needs to be animated without having to mark
/// some sort of state for whether or not its being dismissed or presented.
///
/// It also allows us to access private variables/properties without having to expose them to the animation controller.
@interface BATBasicAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/// Whether or not this animation controller is being used for presentation or dismissal
@property (readonly) BATAnimationDirection direction;

/// The controller to handle animating
@property (readonly, weak) id<BATBasicAnimationControllerDelgate> delegate;

- (instancetype)initWithDirection:(BATAnimationDirection)direction delegate:(id<BATBasicAnimationControllerDelgate>)delegate;

@end

NS_ASSUME_NONNULL_END
