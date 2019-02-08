//
//  BATLedgerGrant.m
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-18.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import "BATLedgerGrant.h"

#import "bat/ledger/grant.h"

@interface BATLedgerGrant ()
@property (nonatomic, copy) NSString *altcurrency;
@property (nonatomic, copy) NSString *probi;
@property (nonatomic, copy) NSString *promotionId;
@property (nonatomic) UInt64 expiryTime;
@end

@implementation BATLedgerGrant

- (instancetype)initWithGrant:(const ledger::Grant&)grant
{
  if ((self = [super init])) {
    self.altcurrency = [NSString stringWithUTF8String:grant.altcurrency.c_str()];
    self.probi = [NSString stringWithUTF8String:grant.probi.c_str()];
    self.promotionId = [NSString stringWithUTF8String:grant.promotionId.c_str()];
    self.expiryTime = grant.expiryTime;
  }
  return self;
}

@end
