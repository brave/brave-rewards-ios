/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class BATActionButton;

NS_ASSUME_NONNULL_BEGIN

@interface BATWalletHeaderView : UIView
@property (readonly) UIImageView *backgroundImageView;
@property (readonly) UILabel *titleLabel;
@property (readonly) UILabel *batBalanceLabel;
@property (readonly) UILabel *usdBalanceLabel;
@property (readonly) BATActionButton *grantsButton;
@property (readonly) UIButton *addFundsButton;
@property (readonly) UIButton *settingsButton;
@end

NS_ASSUME_NONNULL_END
