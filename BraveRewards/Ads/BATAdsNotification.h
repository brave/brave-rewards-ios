/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AdsNotification)
@interface BATAdsNotification : NSObject
@property (nonatomic, readonly, copy) NSString *creativeSetID;
@property (nonatomic, readonly, copy) NSString *category;
@property (nonatomic, readonly, copy) NSString *advertiser;
@property (nonatomic, readonly, copy) NSString *text;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, readonly, copy) NSString *uuid;
@end

NS_ASSUME_NONNULL_END
