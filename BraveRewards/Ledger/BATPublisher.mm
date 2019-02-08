/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPublisher.h"

#import "bat/ledger/publisher_info.h"

@interface BATPublisher ()
@property (nonatomic) UInt64 duration;
@property (nonatomic) double score;
@property (nonatomic) int year;
@property (nonatomic) BATPublisherActivityMonth month;
@property (nonatomic) UInt64 reconcileStamp;
@property (nonatomic) UInt32 visits;
@property (nonatomic) UInt32 percent;
@property (nonatomic) double weight;
@property (nonatomic) BATPublisherRewardsCategory rewardsCategory;
@property (nonatomic) BATPublisherExclude excluded;
@property (nonatomic, copy) NSURL *faviconURL;
@property (nonatomic, copy) NSString *publisherId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *provider;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic) BOOL verified;
@end

@implementation BATPublisher

- (instancetype)initWithPublisherInfo:(const ledger::PublisherInfo&)info
{
  if ((self = [super init])) {
    self.duration = info.duration;
    self.score = info.score;
    self.year = info.year;
    self.month = (BATPublisherActivityMonth)info.month;
    self.reconcileStamp = info.reconcile_stamp;
    self.visits = info.visits;
    self.percent = info.percent;
    self.weight = info.weight;
    self.rewardsCategory = (BATPublisherRewardsCategory)info.category;
    
    self.excluded = (BATPublisherExclude)info.excluded;
    self.name = [NSString stringWithUTF8String:info.name.c_str()];
    self.provider = [NSString stringWithUTF8String:info.provider.c_str()];
    self.verified = info.verified;
    
    auto const faviconUrlString = [NSString stringWithUTF8String:info.favicon_url.c_str()];
    auto const urlString = [NSString stringWithUTF8String:info.url.c_str()];
    self.faviconURL = [NSURL URLWithString:faviconUrlString];
    self.url = [NSURL URLWithString:urlString];
  }
  return self;
}

- (const ledger::PublisherInfo)publisherInfo
{
  ledger::PublisherInfo info;
  info.duration = self.duration;
  info.score = self.score;
  info.year = self.year;
  info.month = (ledger::ACTIVITY_MONTH)self.month;
  info.reconcile_stamp = self.reconcileStamp;
  info.visits = self.visits;
  info.percent = self.percent;
  info.weight = self.weight;
  info.category = (ledger::REWARDS_CATEGORY)self.rewardsCategory;
  info.excluded = (ledger::PUBLISHER_EXCLUDE)self.excluded;
  info.name = std::string(self.name.UTF8String);
  info.provider = std::string(self.provider.UTF8String);
  info.url = std::string(self.url.absoluteString.UTF8String);
  info.favicon_url = std::string(self.faviconURL.absoluteString.UTF8String);
  info.verified = self.verified;
  return info;
}

@end
