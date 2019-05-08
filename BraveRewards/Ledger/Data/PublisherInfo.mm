/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "PublisherInfo.h"
#import "DataController.h"
#import "ActivityInfo.h"
#import "ContributionInfo+CoreDataClass.h"
#import "RecurringDonation+CoreDataClass.h"
#import "Records.h"

@implementation PublisherInfo

+ (NSArray<BATPublisherInfo *> *)publishersWithActivityFromOffset:(uint32_t)start limit:(uint32_t)limit filter:(BATActivityInfoFilter *)filter
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = ActivityInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(ActivityInfo.class)
                                    inManagedObjectContext:context];
  if (limit > 0) {
    fetchRequest.fetchLimit = limit;
    if (start > 1) {
      fetchRequest.fetchOffset = start;
    }
  }
  
  NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
  for (BATActivityInfoFilterOrderPair *orderPair in filter.orderBy) {
    [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:orderPair.propertyName ascending:orderPair.ascending]];
  }
  fetchRequest.sortDescriptors = sortDescriptors;
  
  const auto predicates = [[NSMutableArray<NSPredicate *> alloc] init];
  
  if (filter.id.length > 0) {
    [predicates addObject:[NSPredicate predicateWithFormat:@"publisherID == %@", filter.id]];
  }
  
  if (filter.reconcileStamp > 0) {
    [predicates addObject:[NSPredicate predicateWithFormat:@"reconcileStamp == %ld", filter.reconcileStamp]];
  }
  
  if (filter.minDuration > 0) {
    [predicates addObject:[NSPredicate predicateWithFormat:@"duration >= %ld", filter.reconcileStamp]];
  }
  
  if (filter.excluded != BATExcludeFilterFilterAll) {
    if (filter.excluded != BATExcludeFilterFilterAllExceptExcluded) {
      [predicates addObject:[NSPredicate predicateWithFormat:@"excluded == %d", filter.excluded]];
    } else {
      [predicates addObject:[NSPredicate predicateWithFormat:@"excluded != %d", BATExcludeFilterFilterExcluded]];
    }
  }
  
  if (filter.percent) {
    [predicates addObject:[NSPredicate predicateWithFormat:@"percent >= %d", filter.percent]];
  }
  
  if (filter.minVisits) {
    [predicates addObject:[NSPredicate predicateWithFormat:@"visits >= %d", filter.minVisits]];
  }
  
  if (predicates.count > 0) {
    fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
  }
  
  const auto frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:context
                                                         sectionNameKeyPath:nil
                                                                  cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  const auto publishers = [[NSMutableArray<BATPublisherInfo *> alloc] init];
  for (ActivityInfo *activity in frc.fetchedObjects) {
    auto info = [[BATPublisherInfo alloc] init];
    info.id = activity.publisherID;
    info.score = activity.score;
    info.percent = activity.percent;
    info.weight = activity.weight;
    info.verified = activity.publisher.verified;
    info.excluded = (BATPublisherExclude)activity.publisher.excluded;
    info.name = activity.publisher.name;
    info.url = activity.publisher.url.absoluteString;
    info.provider = activity.publisher.provider;
    info.faviconUrl = activity.publisher.faviconURL.absoluteString;
    info.reconcileStamp = activity.reconcileStamp;
    info.visits = activity.visits;
    [publishers addObject:info];
  }
  return publishers;
}

+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = self.fetchRequest;
  fetchRequest.includesSubentities = NO;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(self.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = predicate;
  
  NSError *error;
  const auto count = [context countForFetchRequest:fetchRequest error:&error];
  if (count == NSNotFound) {
    NSLog(@"Failed to get count: %@", error);
    return 0;
  }
  return count;
}

+ (NSArray<BATPublisherInfo *> *)oneTimeTipsForMonth:(BATActivityMonth)month year:(int)year
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = ContributionInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(ContributionInfo.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"month = %d AND year = %d AND category = %d",
                            month, year, BATRewardsCategoryOneTimeTip];
  
  const auto frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:context
                                                         sectionNameKeyPath:nil
                                                                  cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  const auto publishers = [[NSMutableArray<BATPublisherInfo *> alloc] init];
  for (ContributionInfo *ci in frc.fetchedObjects) {
    auto info = [[BATPublisherInfo alloc] init];
    info.id = ci.publisherID;
    info.name = ci.publisher.name;
    info.url = ci.publisher.url.absoluteString;
    info.faviconUrl = ci.publisher.faviconURL.absoluteString;
    info.weight = [ci.probi doubleValue];
    info.reconcileStamp = ci.date;
    info.verified = ci.publisher.verified;
    info.provider = ci.publisher.provider;
    [publishers addObject:info];
  }
  return publishers;
}

+ (NSArray<BATPublisherInfo *> *)recurringTipsForMonth:(BATActivityMonth)month year:(int)year
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = RecurringDonation.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(RecurringDonation.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"month = %d AND year = %d AND category = %d",
                            month, year, BATRewardsCategoryOneTimeTip];
  
  const auto frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:context
                                                         sectionNameKeyPath:nil
                                                                  cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  const auto publishers = [[NSMutableArray<BATPublisherInfo *> alloc] init];
  for (RecurringDonation *rd in frc.fetchedObjects) {
    auto info = [[BATPublisherInfo alloc] init];
    info.id = rd.publisherID;
    info.name = rd.publisher.name;
    info.url = rd.publisher.url.absoluteString;
    info.faviconUrl = rd.publisher.faviconURL.absoluteString;
    info.weight = rd.amount;
    info.reconcileStamp = rd.addedDate;
    info.verified = rd.publisher.verified;
    info.provider = rd.publisher.provider;
    [publishers addObject:info];
  }
  return publishers;
}

@end
