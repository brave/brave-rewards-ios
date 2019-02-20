/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>
#import "BATSendTipButton.h"
#import "BATButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BATTippingView : UIView
@property (readonly) UILabel *walletBalanceValueLabel; // "25"
@property (readonly) UILabel *walletBalanceCryptoLabel; // "BAT"
@property (readonly) UIStackView *amountStackView;
@property (readonly) BATButton *monthlyToggleButton;
@property (readonly) BATSendTipButton *sendTipButton;
@end

NS_ASSUME_NONNULL_END
