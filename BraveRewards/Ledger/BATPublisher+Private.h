/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPublisher.h"

#import "bat/ledger/publisher_info.h"

@interface BATPublisher (Private)

- (instancetype)initWithPublisherInfo:(const ledger::PublisherInfo&)info;
- (const ledger::PublisherInfo)publisherInfo;

@end
