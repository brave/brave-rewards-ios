/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class BATBraveLedger;

NS_ASSUME_NONNULL_BEGIN

@interface BraveRewardsPanelController : UIViewController

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
                           url:(NSURL *)url
                       isLocal:(BOOL)isLocal
                       favicon:(nullable UIImage *)favicon NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
