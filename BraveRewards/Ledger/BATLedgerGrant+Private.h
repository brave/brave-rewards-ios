//
//  BATLedgerGrant+Private.h
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-21.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import "BATLedgerGrant.h"

#import "bat/ledger/grant.h"

@interface BATLedgerGrant (Private)

- (instancetype)initWithGrant:(const ledger::Grant&)grant;

@end
