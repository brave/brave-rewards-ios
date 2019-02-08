/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Grant)
@interface BATLedgerGrant : NSObject
/// What kind of currency or utility token is in use (will be "BAT" in this case)
@property (nonatomic, readonly, copy) NSString *altcurrency;
/// The probi amount (10^18 wei)
@property (nonatomic, readonly, copy) NSString *probi;
/// The grant promotion id
@property (nonatomic, readonly, copy) NSString *promotionId;
/// The time this grant expires
@property (nonatomic, readonly) UInt64 expiryTime;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
