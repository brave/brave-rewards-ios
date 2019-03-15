/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>
#import "BraveRewardsDataSource.h"
#import "BraveRewardsDataDelegate.h"

@class BATBraveLedger;

NS_ASSUME_NONNULL_BEGIN

@interface BraveRewardsPanelController : UINavigationController

/// The logo to display in the toolbar to display this panel
@property (class, readonly) UIImage *batLogoImage;

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
                           url:(NSURL *)url
                    faviconURL:(nullable NSURL *)faviconURL
                      delegate:(id<BraveRewardsDelegate>)delegate
                    dataSource:(id<BraveRewardsDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
