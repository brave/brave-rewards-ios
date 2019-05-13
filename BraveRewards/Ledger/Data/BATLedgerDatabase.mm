/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATLedgerDatabase.h"

#import "DataController.h"
#import "Model+CoreDataModel.h"

@implementation BATLedgerDatabase

+ (PublisherInfo *)getOrCreatePublisherInfoWithID:(NSString *)publisherID
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = PublisherInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(PublisherInfo.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"publisherID == %@", publisherID];
  
  const auto frc = [[NSFetchedResultsController<PublisherInfo *> alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  if (frc.fetchedObjects.firstObject != nil) {
    // One exists, return it
    return frc.fetchedObjects.firstObject;
  }
  
  // Create one
  PublisherInfo *__block pi;
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    pi = [[PublisherInfo alloc] initWithEntity:PublisherInfo.entity
                insertIntoManagedObjectContext:context];
    pi.publisherID = publisherID;
  }];
  return pi;
}

+ (nullable ActivityInfo *)getActivityInfoWithPublisherID:(NSString *)publisherID
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = ActivityInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(ActivityInfo.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"publisherID == %@", publisherID];
  
  const auto frc = [[NSFetchedResultsController<ActivityInfo *> alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  if (frc.fetchedObjects.firstObject != nil) {
    // One exists, return it
    return frc.fetchedObjects.firstObject;
  }
  return nil;
}

+ (nullable MediaPublisherInfo *)getMediaPublisherInfoWithMediaKey:(NSString *)mediaKey
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = MediaPublisherInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(MediaPublisherInfo.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"mediaKey == %@", mediaKey];
  
  const auto frc = [[NSFetchedResultsController<MediaPublisherInfo *> alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:context
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  if (frc.fetchedObjects.firstObject != nil) {
    // One exists, return it
    return frc.fetchedObjects.firstObject;
  }
  return nil;
}

+ (nullable RecurringDonation *)getRecurringDonationWithPublisherID:(NSString *)publisherID
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = RecurringDonation.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(RecurringDonation.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"publisherID == %@", publisherID];
  
  const auto frc = [[NSFetchedResultsController<RecurringDonation *> alloc] initWithFetchRequest:fetchRequest
                                                                             managedObjectContext:context
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  if (frc.fetchedObjects.firstObject != nil) {
    // One exists, return it
    return frc.fetchedObjects.firstObject;
  }
  return nil;
}

#pragma mark - Publisher Info

+ (BATPublisherInfo *)publisherInfoWithPublisherID:(NSString *)publisherID
{
  auto databaseInfo = [self getOrCreatePublisherInfoWithID:publisherID];
  auto info = [[BATPublisherInfo alloc] init];
  info.id = databaseInfo.publisherID;
  info.name = databaseInfo.name;
  info.url = databaseInfo.url.absoluteString;
  info.faviconUrl = databaseInfo.faviconURL.absoluteString;
  info.provider = databaseInfo.provider;
  info.verified = databaseInfo.verified;
  info.excluded = (BATPublisherExclude)databaseInfo.excluded;
  return info;
}

+ (BATPublisherInfo *)panelPublisherWithFilter:(BATActivityInfoFilter *)filter
{
  const auto info = [self publisherInfoWithPublisherID:filter.id];
  const auto activity = [self getActivityInfoWithPublisherID:filter.id];
  if (activity) {
    info.percent = activity.percent;
  }
  return info;
}

+ (void)insertOrUpdatePublisherInfo:(BATPublisherInfo *)info
{
  if (info.id.length == 0) {
    return;
  }
  
  void (^updateInfo)(PublisherInfo *) = ^(PublisherInfo *pi) {
    pi.publisherID = info.id;
    pi.verified = info.verified;
    pi.excluded = info.excluded;
    pi.name = info.name;
    pi.url = [NSURL URLWithString:info.url];
    pi.provider = info.provider;
    pi.faviconURL = [NSURL URLWithString:info.faviconUrl];
  };
  
  const auto pi = [self getOrCreatePublisherInfoWithID:info.id];
  if (pi) {
    updateInfo(pi);
    return;
  }
  
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    auto pi = [[PublisherInfo alloc] initWithEntity:PublisherInfo.entity
                     insertIntoManagedObjectContext:context];
    updateInfo(pi);
  }];
}

+ (void)restoreExcludedPublishers
{
  const auto context = DataController.viewContext;
  
  NSBatchUpdateRequest *request = [[NSBatchUpdateRequest alloc] initWithEntity:PublisherInfo.entity];
  request.resultType = NSUpdatedObjectIDsResultType;
  request.predicate = [NSPredicate predicateWithFormat:@"excluded == %d", BATPublisherExcludeExcluded];
  request.propertiesToUpdate = @{ @"excluded": @(BATPublisherExcludeDefault) };
  
  NSError *error;
  NSBatchUpdateResult *updateResult = [DataController.newBackgroundContext executeRequest:request error:&error];
  if (error) {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    return;
  }
  
  NSArray<NSManagedObjectID *> *updatedObjects = updateResult.result;
  auto changes = @{ NSUpdatedObjectsKey : updatedObjects };
  [NSManagedObjectContext mergeChangesFromRemoteContextSave:changes intoContexts:@[ context ]];
  [context save:nil];
}

+ (NSUInteger)excludedPublishersCount
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = ActivityInfo.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(PublisherInfo.class)
                                    inManagedObjectContext:context];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"excluded == %d", BATPublisherExcludeExcluded];
  
  NSError *error;
  const auto count = [context countForFetchRequest:fetchRequest error:&error];
  if (error) {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
  }
  return count;
}

#pragma mark - Contribution Info

+ (void)insertContributionInfo:(NSString *)probi month:(const int)month year:(const int)year date:(const uint32_t)date publisherKey:(NSString *)publisherKey category:(BATRewardsCategory)category
{
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    auto ci = [[ContributionInfo alloc] initWithEntity:ContributionInfo.entity
                        insertIntoManagedObjectContext:context];
    ci.probi = probi;
    ci.month = month;
    ci.year = year;
    ci.date = date;
    ci.publisherID = publisherKey;
    ci.category = category;
    ci.publisher = [self getOrCreatePublisherInfoWithID:publisherKey];
  }];
}

+ (NSArray<BATPublisherInfo *> *)oneTimeTipsPublishersForMonth:(BATActivityMonth)month year:(int)year
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

#pragma mark - Activity Info

+ (void)insertOrUpdateActivityInfoFromPublisher:(BATPublisherInfo *)info
{
  if (info.id.length == 0) {
    return;
  }
  
  [self insertOrUpdatePublisherInfo:info];
  
  void (^updateInfo)(ActivityInfo *) = ^(ActivityInfo *ai) {
    ai.publisher = [self getOrCreatePublisherInfoWithID:info.id];
    ai.publisherID = info.id;
    ai.duration = info.duration;
    ai.score = info.score;
    ai.percent = info.percent;
    ai.weight = info.weight;
    ai.reconcileStamp = info.reconcileStamp;
    ai.visits = info.visits;
  };
  
  const auto ai = [self getActivityInfoWithPublisherID:info.id];
  if (ai) {
    updateInfo(ai);
    return;
  }
  
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    auto ai = [[ActivityInfo alloc] initWithEntity:ActivityInfo.entity
                    insertIntoManagedObjectContext:context];
    updateInfo(ai);
  }];
}

+ (void)insertOrUpdateActivitiesInfoFromPublishers:(NSArray<BATPublisherInfo *> *)publishers
{
  for (BATPublisherInfo *info in publishers) {
    [self insertOrUpdatePublisherInfo:info];
  }
}

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

+ (void)deleteWithPublisherID:(NSString *)publisherID reconcileStamp:(uint64_t)reconcileStamp
{
  const auto context = DataController.viewContext;
  const auto request = ActivityInfo.fetchRequest;
  request.entity = [NSEntityDescription entityForName:NSStringFromClass(ActivityInfo.class)
                               inManagedObjectContext:context];
  request.predicate = [NSPredicate predicateWithFormat:@"publisherID == %@ AND reconcileStamp == %ld", publisherID, reconcileStamp];
  
  NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
  deleteRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
  
  NSError *error;
  NSBatchDeleteResult *deleteResult = [DataController.newBackgroundContext executeRequest:request error:&error];
  if (error) {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    return;
  }
  
  NSArray<NSManagedObjectID *> *updatedObjects = deleteResult.result;
  auto changes = @{ NSUpdatedObjectsKey : updatedObjects };
  [NSManagedObjectContext mergeChangesFromRemoteContextSave:changes intoContexts:@[ context ]];
  [context save:nil];
}

#pragma mark - Media Publisher Info

+ (BATPublisherInfo *)mediaPublisherInfoWithMediaKey:(NSString *)mediaKey
{
  const auto mi = [self getMediaPublisherInfoWithMediaKey:mediaKey];
  if (!mi) {
    return nil;
  }
  // As far as I know, there is no data that is actually coming from MediaPublisherInfo, just basically
  // here to grab a publisher info object with a media key
  return [self publisherInfoWithPublisherID:mi.publisherID];
}

+ (void)insertOrUpdateMediaPublisherInfoWithMediaKey:(NSString *)mediaKey publisherID:(NSString *)publisherID
{
  if (mediaKey.length == 0 || publisherID.length == 0) {
    return;
  }
  
  void (^updateInfo)(MediaPublisherInfo *) = ^(MediaPublisherInfo *mi) {
    mi.mediaKey = mediaKey;
    mi.publisherID = publisherID;
  };
  
  const auto mi = [self getMediaPublisherInfoWithMediaKey:mediaKey];
  if (mi) {
    updateInfo(mi);
    return;
  }
  
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    auto mi = [[MediaPublisherInfo alloc] initWithEntity:MediaPublisherInfo.entity
                          insertIntoManagedObjectContext:context];
    updateInfo(mi);
  }];
}

#pragma mark - Recurring Tips

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

+ (void)insertOrUpdateRecurringTipWithPublisherID:(NSString *)publisherID
                                           amount:(double)amount
                                        dateAdded:(uint32_t)dateAdded
{
  if (publisherID.length == 0) {
    return;
  }
  
  void (^updateInfo)(RecurringDonation *) = ^(RecurringDonation *rd) {
    rd.publisherID = publisherID;
    rd.amount = amount;
    rd.addedDate = dateAdded;
    rd.publisher = [self getOrCreatePublisherInfoWithID:publisherID];
  };
  
  const auto rd = [self getRecurringDonationWithPublisherID:publisherID];
  if (rd) {
    updateInfo(rd);
    return;
  }
  
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    auto rd = [[RecurringDonation alloc] initWithEntity:RecurringDonation.entity
                         insertIntoManagedObjectContext:context];
    updateInfo(rd);
  }];
}

+ (void)removeRecurringTipWithPublisherID:(NSString *)publisherID
{
  const auto rd = [self getRecurringDonationWithPublisherID:publisherID];
  [DataController.viewContext deleteObject:rd];
}

#pragma mark - Pending Contributions

+ (void)insertPendingContributions:(BATPendingContributionList *)contributions
{
  const auto now = [[NSDate date] timeIntervalSince1970];
  [DataController.shared performOnContext:DataController.newBackgroundContext task:^(NSManagedObjectContext * _Nonnull context) {
    for (BATPendingContribution *contribution in contributions.list) {
      auto pc = [[PendingContribution alloc] initWithEntity:PendingContribution.entity
                             insertIntoManagedObjectContext:context];
      pc.publisherID = contribution.publisherKey;
      pc.amount = contribution.amount;
      pc.addedDate = now;
      pc.viewingID = contribution.viewingId;
      pc.category = contribution.category;
    }
  }];
}

+ (double)reservedAmountForPendingContributions
{
  const auto context = DataController.viewContext;
  const auto fetchRequest = PendingContribution.fetchRequest;
  fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(PendingContribution.class)
                                    inManagedObjectContext:context];
  
  const auto frc = [[NSFetchedResultsController<PendingContribution *> alloc] initWithFetchRequest:fetchRequest
                                                                             managedObjectContext:context
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
  
  NSError *error;
  if (![frc performFetch:&error]) {
    NSLog(@"%@", error);
  }
  
  return [[frc.fetchedObjects valueForKeyPath:@"@sum.amount"] doubleValue];
}

@end
