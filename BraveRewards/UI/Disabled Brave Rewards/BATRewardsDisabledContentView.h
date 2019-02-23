/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class ActionButton;

NS_ASSUME_NONNULL_BEGIN

/// A view displayed under the wallet header when brave rewards is disabled in the settings
@interface BATRewardsDisabledContentView : UIView
@property (readonly) UIImageView *batLogoImageView;
@property (readonly) UILabel *titleLabel; // "Welcome back!"
@property (readonly) UILabel *subtitleLabel; // "Get rewarded for browsing."
@property (readonly) UILabel *bodyLabel; // "Earn by viewing privacy-respecting ads..."
@property (readonly) ActionButton *enableRewardsButton;
@end

NS_ASSUME_NONNULL_END
