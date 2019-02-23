/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class ActionButton, GradientView;

NS_ASSUME_NONNULL_BEGIN

@interface BATCreateWalletView : UIView
@property (readonly) GradientView *gradientView;
@property (readonly) UIImageView *watermarkImageView;
@property (readonly) UILabel *prefixLabel; // "Get ready for the next experience"
@property (readonly) UIImageView *batLogoImageView;
@property (readonly) UILabel *titleLabel; // "Brave Rewards™"
@property (readonly) UILabel *descriptionLabel; // "Get paid for viewing ads and pay it forward to support..."
@property (readonly) ActionButton *createWalletButton;
@property (readonly) UIButton *learnMoreButton;
@end

NS_ASSUME_NONNULL_END
