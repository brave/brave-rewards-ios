/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BATActivityInfoFilter.h"

@class BATPublisherInfo;

NS_ASSUME_NONNULL_BEGIN

@interface PublisherInfo : NSManagedObject

+ (NSArray<BATPublisherInfo *> *)publishersWithActivityFromOffset:(uint32_t)start
                                                            limit:(uint32_t)limit
                                                           filter:(nullable BATActivityInfoFilter *)filter;

+ (NSArray<BATPublisherInfo *> *)oneTimeTipsForMonth:(BATActivityMonth)month year:(int)year;

+ (NSArray<BATPublisherInfo *> *)recurringTipsForMonth:(BATActivityMonth)month year:(int)year;

+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

@end

NS_ASSUME_NONNULL_END

#import "PublisherInfo+CoreDataProperties.h"
