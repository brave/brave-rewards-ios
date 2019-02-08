/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

#import "bat/ledger/ledger.h"

#import "BATBraveLedger.h"
#import "BATPublisher+Private.h"
#import "NSURL+Extensions.h"

#import "NativeLedgerClient.h"

#define BATLedgerReadonlyBridge(__type, __objc_getter, __cpp_getter) \
- (__type)__objc_getter { return ledgerClient->ledger->__cpp_getter(); }

#define BATLedgerBridge(__type, __objc_getter, __objc_setter, __cpp_getter, __cpp_setter) \
- (__type)__objc_getter { return ledgerClient->ledger->__cpp_getter(); } \
- (void)__objc_setter:(__type)newValue { ledgerClient->ledger->__cpp_setter(newValue); }

NSString * const BATBraveLedgerErrorDomain = @"BATBraveLedgerErrorDomain";

@interface BATBraveLedger () {
  ledger::NativeLedgerClient *ledgerClient;
}
@end

@implementation BATBraveLedger

- (instancetype)init
{
  if ((self = [super init])) {    
    ledgerClient = new ledger::NativeLedgerClient(self);
    ledgerClient->ledger->Initialize();
    
    // Add notifications for standard app foreground/background
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
  }
  return self;
}

- (void)dealloc
{
  [NSNotificationCenter.defaultCenter removeObserver:self];
  delete ledgerClient;
}

#pragma mark - Wallet

BATLedgerReadonlyBridge(BOOL, isWalletCreated, IsWalletCreated)

- (void)createWallet:(void (^)(NSError * _Nullable))completion
{
  const auto __weak weakSelf = self;
  ledgerClient->walletInitializedBlock = ^(const ledger::Result result) {
    const auto strongSelf = weakSelf;
    if (!strongSelf) { return; }
    NSError *error = nil;
    if (result != ledger::WALLET_CREATED) {
      std::map<ledger::Result, std::string> errorDescriptions {
        { ledger::Result::LEDGER_ERROR, "The wallet was already initialized" },
        { ledger::Result::BAD_REGISTRATION_RESPONSE, "Request credentials call failure or malformed data" },
        { ledger::Result::REGISTRATION_VERIFICATION_FAILED, "Missing master user token from registered persona" },
      };
      NSDictionary *userInfo = @{};
      const auto description = errorDescriptions[result];
      if (description.length() > 0) {
        userInfo = @{ NSLocalizedDescriptionKey: [NSString stringWithUTF8String:description.c_str()] };
      }
      error = [NSError errorWithDomain:BATBraveLedgerErrorDomain code:result userInfo:userInfo];
    }
    if (completion) {
      completion(error);
    }
    strongSelf->ledgerClient->walletInitializedBlock = nullptr;
  };
  // Results that can come from CreateWallet():
  //   - WALLET_CREATED: Good to go
  //   - LEDGER_ERROR: Already initialized
  //   - BAD_REGISTRATION_RESPONSE: Request credentials call failure or malformed data
  //   - REGISTRATION_VERIFICATION_FAILED: Missing master user token
  ledgerClient->ledger->CreateWallet();
}

- (NSString *)walletPassphrase
{
  if (ledgerClient->ledger->IsWalletCreated()) {
    return [NSString stringWithUTF8String:ledgerClient->ledger->GetWalletPassphrase().c_str()];
  }
  return nil;
}

- (void)recoverWalletUsingPassphrase:(NSString *)passphrase completion:(void (^)(NSError *_Nullable))completion
{
  const auto __weak weakSelf = self;
  ledgerClient->walletRecoveredBlock = ^(const ledger::Result result, const double balance, const NSArray<BATLedgerGrant *> *grants) {
    const auto strongSelf = weakSelf;
    if (!strongSelf) { return; }
    NSError *error = nil;
    if (result != ledger::LEDGER_OK) {
      std::map<ledger::Result, std::string> errorDescriptions {
        { ledger::Result::LEDGER_ERROR, "The recovery failed" },
      };
      NSDictionary *userInfo = @{};
      const auto description = errorDescriptions[result];
      if (description.length() > 0) {
        userInfo = @{ NSLocalizedDescriptionKey: [NSString stringWithUTF8String:description.c_str()] };
      }
      error = [NSError errorWithDomain:BATBraveLedgerErrorDomain code:result userInfo:userInfo];
    }
    if (completion) {
      completion(error);
    }
    strongSelf->ledgerClient->walletRecoveredBlock = nullptr;
  };
  // Results that can come from CreateWallet():
  //   - LEDGER_OK: Good to go
  //   - LEDGER_ERROR: Recovery failed
  ledgerClient->ledger->RecoverWallet(std::string(passphrase.UTF8String));
}

- (NSString *)BATAddress
{
  if (ledgerClient->ledger->IsWalletCreated()) {
    return [NSString stringWithUTF8String:ledgerClient->ledger->GetBATAddress().c_str()];
  }
  return nil;
}

- (NSString *)BTCAddress
{
  if (ledgerClient->ledger->IsWalletCreated()) {
    return [NSString stringWithUTF8String:ledgerClient->ledger->GetBTCAddress().c_str()];
  }
  return nil;
}

- (NSString *)ETHAddress
{
  if (ledgerClient->ledger->IsWalletCreated()) {
    return [NSString stringWithUTF8String:ledgerClient->ledger->GetETHAddress().c_str()];
  }
  return nil;
}

- (NSString *)LTCAddress
{
  if (ledgerClient->ledger->IsWalletCreated()) {
    return [NSString stringWithUTF8String:ledgerClient->ledger->GetLTCAddress().c_str()];
  }
  return nil;
}

BATLedgerReadonlyBridge(double, balance, GetBalance);

BATLedgerReadonlyBridge(double, defaultContributionAmount, GetDefaultContributionAmount);

BATLedgerReadonlyBridge(BOOL, hasSufficientBalanceToReconcile, HasSufficientBalanceToReconcile);

#pragma mark - Publishers

BATLedgerReadonlyBridge(UInt32, numberOfExcludedSites, GetNumExcludedSites);

- (void)addRecurringPaymentToPublisherWithId:(NSString *)publisherId amount:(double)amount
{
  ledgerClient->ledger->AddRecurringPayment(std::string(publisherId.UTF8String), amount);
}

- (void)makeDirectDonation:(BATPublisher *)publisher amount:(int)amount currency:(NSString *)currency
{
  ledgerClient->ledger->DoDirectDonation(publisher.publisherInfo, amount, std::string(currency.UTF8String));
}

- (void)updatePublisherWithId:(NSString *)publisherId exclusionState:(BATPublisherExclude)excludeState
{
  ledgerClient->ledger->SetPublisherExclude(std::string(publisherId.UTF8String),
                                            (ledger::PUBLISHER_EXCLUDE)excludeState);
}

#pragma mark -

- (void)handleUpdatedWallet:(ledger::Result)result walletInfo:(std::unique_ptr<ledger::WalletInfo>)info
{
  // Results that can come from OnWalletProperties:
  //   - CORRUPTED_WALLET: Payment ID or Passphase is empty
  //   - LEDGER_ERROR: Network call to get wallet properties failed or failed to parse json
  //   - LEDGER_OK: Good to go
  if (result != ledger::LEDGER_OK) {
    return;
  }
}

#pragma mark - Reporting

- (const ledger::VisitData)visitDataForURL:(NSURL *)url tabId:(UInt32)tabId
{
  const auto dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
  const auto normalizedHost = std::string(url.bat_normalizedHost.UTF8String);
  ledger::VisitData visit(normalizedHost,
                          std::string(url.host.UTF8String),
                          std::string(url.path.UTF8String),
                          tabId,
                          (ledger::ACTIVITY_MONTH)dateComponents.month,
                          (UInt32)dateComponents.year,
                          normalizedHost,
                          std::string(url.absoluteString.UTF8String),
                          "",
                          "");
  return visit;
}

- (void)setSelectedTabId:(UInt32)selectedTabId
{
  if (selectedTabId != 0) {
    ledgerClient->ledger->OnHide(_selectedTabId, [[NSDate date] timeIntervalSince1970]);
  }
  _selectedTabId = selectedTabId;
  ledgerClient->ledger->OnShow(_selectedTabId, [[NSDate date] timeIntervalSince1970]);
}

- (void)applicationDidBecomeActive
{
  ledgerClient->ledger->OnForeground(self.selectedTabId, [[NSDate date] timeIntervalSince1970]);
}

- (void)applicationDidBackground
{
  ledgerClient->ledger->OnBackground(self.selectedTabId, [[NSDate date] timeIntervalSince1970]);
}

- (void)reportLoadedPageWithURL:(NSURL *)url tabId:(UInt32)tabId
{
  const auto visit = [self visitDataForURL:url tabId:tabId];
  ledgerClient->ledger->OnLoad(visit, [[NSDate date] timeIntervalSince1970]);
}

- (void)reportXHRLoad:(NSURL *)url tabId:(UInt32)tabId firstPartyURL:(NSURL *)firstPartyURL referrerURL:(NSURL *)referrerURL
{
  std::map<std::string, std::string> partsMap;
  const auto urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
  for (NSURLQueryItem *item in urlComponents.queryItems) {
    partsMap[std::string(item.name.UTF8String)] = std::string(item.value.UTF8String);
  }
  
  const auto dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
  ledger::VisitData visit("", "",
                          std::string(url.absoluteString.UTF8String),
                          tabId,
                          (ledger::ACTIVITY_MONTH)dateComponents.month,
                          (UInt32)dateComponents.year,
                          "", "", "", "");
  
  ledgerClient->ledger->OnXHRLoad(tabId,
                                  std::string(url.absoluteString.UTF8String),
                                  partsMap,
                                  std::string(firstPartyURL.absoluteString.UTF8String),
                                  std::string(referrerURL.absoluteString.UTF8String),
                                  visit);
}

- (void)reportPostData:(NSData *)postData url:(NSURL *)url tabId:(UInt32)tabId firstPartyURL:(NSURL *)firstPartyURL referrerURL:(NSURL *)referrerURL
{
  const auto dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
  ledger::VisitData visit("", "",
                          std::string(url.absoluteString.UTF8String),
                          tabId,
                          (ledger::ACTIVITY_MONTH)dateComponents.month,
                          (UInt32)dateComponents.year,
                          "", "", "", "");
  
  const auto postDataString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
  
  ledgerClient->ledger->OnPostData(std::string(url.absoluteString.UTF8String),
                                   std::string(firstPartyURL.absoluteString.UTF8String),
                                   std::string(referrerURL.absoluteString.UTF8String),
                                   std::string(postDataString.UTF8String),
                                   visit);
}

- (void)reportMediaStartedWithTabId:(UInt32)tabId
{
  ledgerClient->ledger->OnMediaStart(tabId, [[NSDate date] timeIntervalSince1970]);
}

- (void)reportMediaStoppedWithTabId:(UInt32)tabId
{
  ledgerClient->ledger->OnMediaStop(tabId, [[NSDate date] timeIntervalSince1970]);
}

- (void)reportTabClosedWithTabId:(UInt32)tabId
{
  ledgerClient->ledger->OnUnload(tabId, [[NSDate date] timeIntervalSince1970]);
}

#pragma mark - Preferences

BATLedgerBridge(BOOL,
                isEnabled, setEnabled,
                GetRewardsMainEnabled, SetRewardsMainEnabled);

BATLedgerBridge(UInt64,
                minimumVisitDuration, setMinimumVisitDuration,
                GetPublisherMinVisitTime, SetPublisherMinVisitTime);

BATLedgerBridge(UInt32,
                minimumNumberOfVisits, setMinimumNumberOfVisits,
                GetPublisherMinVisits, SetPublisherMinVisits);

BATLedgerBridge(BOOL,
                allowUnverifiedPublishers, setAllowUnverifiedPublishers,
                GetPublisherAllowNonVerified, SetPublisherAllowNonVerified);

BATLedgerBridge(BOOL,
                allowVideos, setAllowVideos,
                GetPublisherAllowVideos, SetPublisherAllowVideos);

BATLedgerBridge(double,
                contributionAmount, setContributionAmount,
                GetContributionAmount, SetContributionAmount);

BATLedgerBridge(BOOL,
                isAutoContributeEnabled, setAutoContributeEnabled,
                GetAutoContribute, SetAutoContribute);

@end
