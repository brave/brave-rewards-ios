/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "ActivityInfo.h"
#import "DataController.h"

@implementation ActivityInfo

+ (void)deleteWithPublisherID:(NSString *)publisherID reconcileStamp:(uint64_t)reconcileStamp
{
  const auto context = DataController.viewContext;
  const auto request = self.fetchRequest;
  request.entity = [NSEntityDescription entityForName:NSStringFromClass(self.class)
                               inManagedObjectContext:context];
  request.predicate = [NSPredicate predicateWithFormat:@"publisherID = %@ AND reconcileStamp = %ld", publisherID, reconcileStamp];
  
  const auto frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                       managedObjectContext:context
                                                         sectionNameKeyPath:nil cacheName:nil];
  if ([frc performFetch:nil]) {
    [DataController.shared performOnContext:nil save:YES task:^(NSManagedObjectContext *_Nonnull context) {
      [frc.fetchedObjects enumerateObjectsUsingBlock:^(ActivityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:[context objectWithID:obj.objectID]];
      }];
    }];
  }
}

@end
