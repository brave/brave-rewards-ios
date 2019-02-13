/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>
#import "BATWalletContentView.h"

@class BATBraveLedger, BATWalletHeaderView;

NS_ASSUME_NONNULL_BEGIN

/// A container which shows the users wallet balance in the header of the panel and shows
/// a content view in the bottom. Should be subclassed
@interface BATWalletViewController : UIViewController

@property (readonly) BATWalletHeaderView *headerView;
@property (nonatomic) UIView<BATWalletContentView> *contentView;

- (instancetype)initWithLedger:(BATBraveLedger *)ledger NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
