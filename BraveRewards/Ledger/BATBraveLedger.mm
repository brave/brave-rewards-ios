/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveLedger.h"

#import "NativeLedgerClient.h"

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
  }
  return self;
}

- (void)dealloc
{
  delete ledgerClient;
}

#pragma mark - Wallet

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
    completion(error);
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
    completion(error);
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

#pragma mark - Preferences

#define BATLedgerReadonlyPreferenceBridge(__type, __objc_getter, __cpp_getter) \
- (__type)__objc_getter { return ledgerClient->ledger->__cpp_getter(); }

#define BATLedgerPreferenceBridge(__type, __objc_getter, __objc_setter, __cpp_getter, __cpp_setter) \
- (__type)__objc_getter { return ledgerClient->ledger->__cpp_getter(); } \
- (void)__objc_setter:(__type)newValue { ledgerClient->ledger->__cpp_setter(newValue); }

BATLedgerPreferenceBridge(BOOL,
                          isEnabled, setEnabled,
                          GetRewardsMainEnabled, SetRewardsMainEnabled);

BATLedgerPreferenceBridge(UInt64,
                          minimumVisitDuration, setMinimumVisitDuration,
                          GetPublisherMinVisitTime, SetPublisherMinVisitTime);

BATLedgerPreferenceBridge(UInt32,
                          minimumNumberOfVisits, setMinimumNumberOfVisits,
                          GetPublisherMinVisits, SetPublisherMinVisits);

BATLedgerPreferenceBridge(BOOL,
                          allowUnverifiedPublishers, setAllowUnverifiedPublishers,
                          GetPublisherAllowNonVerified, SetPublisherAllowNonVerified);

BATLedgerPreferenceBridge(BOOL,
                          allowVideos, setAllowVideos,
                          GetPublisherAllowVideos, SetPublisherAllowVideos);

BATLedgerPreferenceBridge(double,
                          contributionAmount, setContributionAmount,
                          GetContributionAmount, SetContributionAmount);

BATLedgerPreferenceBridge(BOOL,
                          isAutoContributeEnabled, setAutoContributeEnabled,
                          GetAutoContribute, SetAutoContribute);

BATLedgerReadonlyPreferenceBridge(UInt32, numberOfExcludedSites, GetNumExcludedSites);

@end
