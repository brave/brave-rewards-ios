/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>
#import "BATSendTipButton.h"
#import "BATButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BATTippingAmount : NSObject
@property (nonatomic, copy) NSString *value; // "1"
@property (nonatomic, copy) NSString *crypto; // "BAT"
@property (nonatomic) UIImage *cryptoImage;
@property (nonatomic, copy) NSString *dollarValue; // "1.00 USD"
+ (instancetype)amountWithValue:(NSString *)value
                         crypto:(NSString *)crypto
                    cryptoImage:(UIImage *)cryptoImage
                    dollarValue:(NSString *)dollarValue;
@end

@interface BATTippingSelectionView : UIView
@property (readonly) UILabel *walletBalanceValueLabel; // "25"
@property (readonly) UILabel *walletBalanceCryptoLabel; // "BAT"
@property (readonly) BATButton *monthlyToggleButton;
@property (readonly) BATSendTipButton *sendTipButton;

@property (nonatomic) NSArray<BATTippingAmount *> *amountOptions;
@property (nonatomic) NSUInteger selectedAmountIndex;

@end

NS_ASSUME_NONNULL_END
