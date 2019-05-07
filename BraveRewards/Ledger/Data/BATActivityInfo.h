/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <CoreData/CoreData.h>

@class BATPublisher;

NS_ASSUME_NONNULL_BEGIN

@interface BATActivityInfo : NSManagedObject
@property (nonatomic) int32_t category;
@property (nonatomic) int64_t duration;
@property (nonatomic) int32_t month;
@property (nonatomic) int32_t percent;
@property (nonatomic) int64_t reconcileStamp;
@property (nonatomic) double score;
@property (nonatomic) int32_t visits;
@property (nonatomic) double weight;
@property (nonatomic) int32_t year;
@property (nonatomic) BATPublisher *publisher;
@end

NS_ASSUME_NONNULL_END
