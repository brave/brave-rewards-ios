/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATActivityInfoFilter.h"
#import "BATActivityInfoFilter+Private.h"
#import "CppTransformations.h"

@implementation BATActivityInfoFilterOrderPair

- (instancetype)initWithStringBoolPair:(std::pair<std::string, bool>)obj
{
  if ((self = [super init])) {
    self.first = [NSString stringWithUTF8String:obj.first.c_str()];
    self.second = obj.second;
  }
  return self;
}

@end

@implementation BATActivityInfoFilter

- (instancetype)initWithActivityInfoFilter:(const ledger::ActivityInfoFilter&)obj
{
  if ((self = [super init])) {
    self.id = [NSString stringWithUTF8String:obj.id.c_str()];
    self.excluded = (BATExcludeFilter)obj.excluded;
    self.orderBy = NSArrayFromVector(obj.order_by, ^BATActivityInfoFilterOrderPair *(const std::pair<std::string, bool>& o){
      return [[BATActivityInfoFilterOrderPair alloc] initWithStringBoolPair:o];
    });
    self.minDuration = obj.min_duration;
    self.reconcileStamp = obj.reconcile_stamp;
    self.nonVerified = obj.non_verified;
    self.minVisits = obj.min_visits;
  }
  return self;
}

@end
