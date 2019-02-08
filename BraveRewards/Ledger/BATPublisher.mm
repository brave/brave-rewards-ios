//
//  BATPublisher.m
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-21.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import "BATPublisher.h"

#import "bat/ledger/publisher_info.h"

@interface BATPublisher ()
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

@end
