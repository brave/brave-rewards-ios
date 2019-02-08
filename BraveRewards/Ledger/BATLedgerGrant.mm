/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

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
