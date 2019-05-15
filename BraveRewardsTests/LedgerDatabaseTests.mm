// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "DataController.h"
#import "BATLedgerDatabase.h"


@interface InMemoryDataController : DataController
@end

@implementation InMemoryDataController

- (void)addPersistentStoreForContainer:(NSPersistentContainer *)container
{
  const auto description = [[NSPersistentStoreDescription alloc] init];
  description.type = NSInMemoryStoreType;
  container.persistentStoreDescriptions = @[description];
}

@end

@interface LedgerDatabaseTests : XCTestCase
@property (nonatomic, copy, nullable) void (^contextSaveCompletion)();
@end

@implementation LedgerDatabaseTests

- (void)setUp
{
  [super setUp];
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(contextSaved)
                                             name:NSManagedObjectContextDidSaveNotification
                                           object:nil];

  DataController.shared = [[InMemoryDataController alloc] init];
}

- (void)tearDown
{
  [super tearDown];
  [DataController.viewContext reset];
  self.contextSaveCompletion = nil;
  [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Publisher Info

- (void)testNonExistentPublisher
{
  const auto publisher = [BATLedgerDatabase publisherInfoWithPublisherID:@"duckduckgo.com"];
  XCTAssertNil(publisher);
}

- (void)testPublisherAddAndQuery
{
  const auto publisherID = @"brave.com";
  auto info = [[BATPublisherInfo alloc] init];
  info.id = publisherID;
  
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertOrUpdatePublisherInfo:info];
  }];
  
  const auto queriedInfo = [BATLedgerDatabase publisherInfoWithPublisherID:publisherID];
  XCTAssertNotNil(queriedInfo);
  XCTAssertTrue([queriedInfo.id isEqualToString:publisherID]);
}

- (void)testPublisherUpdate
{
  const auto publisherID = @"brave.com";
  auto info = [[BATPublisherInfo alloc] init];
  info.id = publisherID;
  info.duration = 5;
  
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertOrUpdatePublisherInfo:info];
  }];
  
  auto queriedInfo = [BATLedgerDatabase publisherInfoWithPublisherID:publisherID];
  XCTAssertNotNil(queriedInfo);
  XCTAssertTrue([queriedInfo.id isEqualToString:publisherID]);
  XCTAssertEqual(info.duration, 5);
  
  info.duration = 10;
  
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertOrUpdatePublisherInfo:info];
  }];
  
  queriedInfo = [BATLedgerDatabase publisherInfoWithPublisherID:publisherID];
  XCTAssertNotNil(queriedInfo);
  XCTAssertTrue([queriedInfo.id isEqualToString:publisherID]);
  XCTAssertEqual(info.duration, 10);
}

- (void)testRestoringExcludedPublishers
{
  for (NSUInteger i = 0; i < 3; i++) {
    const auto info = [[BATPublisherInfo alloc] init];
    info.id = [NSUUID.UUID UUIDString];
    info.excluded = BATPublisherExcludeExcluded;
    [self backgroundSaveAndWaitForExpectation:^{
      [BATLedgerDatabase insertOrUpdatePublisherInfo:info];
    }];
  }
  
  const auto defaultPublisher = [[BATPublisherInfo alloc] init];
  defaultPublisher.id = [NSUUID.UUID UUIDString];
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertOrUpdatePublisherInfo:defaultPublisher];
  }];
  
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase restoreExcludedPublishers];
  }];
  
  XCTAssertEqual([BATLedgerDatabase excludedPublishersCount], 0);
}

- (void)testNonZeroExcludedCount
{
  const auto excludedPublishersCount = 3;
  for (NSUInteger i = 0; i < excludedPublishersCount; i++) {
    const auto info = [[BATPublisherInfo alloc] init];
    info.id = [NSUUID.UUID UUIDString];
    info.excluded = BATPublisherExcludeExcluded;
    [self backgroundSaveAndWaitForExpectation:^{
      [BATLedgerDatabase insertOrUpdatePublisherInfo:info];
    }];
  }
  
  const auto defaultPublisher = [[BATPublisherInfo alloc] init];
  defaultPublisher.id = [NSUUID.UUID UUIDString];
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertOrUpdatePublisherInfo:defaultPublisher];
  }];
  
  XCTAssertEqual([BATLedgerDatabase excludedPublishersCount], excludedPublishersCount);
}

#pragma mark - Pending Contributions

- (void)testReservedAmount
{
  const auto now = [[NSDate date] timeIntervalSince1970];
  const auto one = [[BATPendingContribution alloc] init];
  one.publisherKey = @"brave.com";
  one.amount = 20.0;
  one.category = BATRewardsCategoryAutoContribute;
  one.addedDate = now;
  one.viewingId = @"";
  
  const auto two = [[BATPendingContribution alloc] init];
  two.publisherKey = @"duckduckgo.com";
  two.amount = 10.0;
  two.category = BATRewardsCategoryAutoContribute;
  two.addedDate = now;
  two.viewingId = @"";
  
  
  const auto list = [[BATPendingContributionList alloc] init];
  list.list = @[one, two];
  
  [self backgroundSaveAndWaitForExpectation:^{
    [BATLedgerDatabase insertPendingContributions:list];
  }];
  
  const auto amount = [BATLedgerDatabase reservedAmountForPendingContributions];
  XCTAssertEqual(amount, 30.0);
}

#pragma mark - Handling background context reads/writes

- (void)contextSaved
{
  if (self.contextSaveCompletion) {
    self.contextSaveCompletion();
  }
}

/// Waits for core data context save notification. Use this for single background context saves if you want to wait
/// for view context to update itself. Unfortunately there is no notification after changes are merged into context.
- (void)backgroundSaveAndWaitForExpectation:(void (^)())task
{
  auto __block saveExpectation = [self expectationWithDescription:NSUUID.UUID.UUIDString];
  self.contextSaveCompletion = ^{
    [saveExpectation fulfill];
  };
  task();
  [self waitForExpectations:@[saveExpectation] timeout:5];
}

@end
