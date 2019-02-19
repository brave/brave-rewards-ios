/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BATRewardsSummaryRow : UIView
@property (readonly) UILabel *titleLabel;
@property (readonly) UILabel *cryptoCurrencyLabel;
@property (readonly) UILabel *cryptoValueLabel;
@property (readonly) UILabel *dollarValueLabel;
+ (instancetype)rowWithTitle:(NSString *)title batValue:(NSString *)batValue usdDollarValue:(NSString *)dollarValue;
@end

NS_ASSUME_NONNULL_END
