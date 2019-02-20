/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BATTippingAmountView : UIControl
@property (readonly) UIImageView *cryptoLogoImageView; // BAT logo
@property (readonly) UILabel *valueLabel; // "1"/"5"/"10"
@property (readonly) UILabel *cryptoLabel; // "BAT"
@property (readonly) UILabel *dollarLabel; // "0.30 USD"
@end

NS_ASSUME_NONNULL_END
