/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class BATActionButton, BATGradientView;

NS_ASSUME_NONNULL_BEGIN

@interface BATCreateWalletView : UIView
@property (readonly) BATGradientView *gradientView;
@property (readonly) UIImageView *watermarkImageView;
@property (readonly) UILabel *prefixLabel; // "Get ready for the next experience"
@property (readonly) UIImageView *batLogoImageView;
@property (readonly) UILabel *titleLabel; // "Brave Rewards™"
@property (readonly) UILabel *descriptionLabel; // "Get paid for viewing ads and pay it forward to support..."
@property (readonly) BATActionButton *createWalletButton;
@property (readonly) UIButton *learnMoreButton;
@end

NS_ASSUME_NONNULL_END
