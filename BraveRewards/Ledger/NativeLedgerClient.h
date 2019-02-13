/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include "bat/ledger/ledger.h"
#import "BATCommonOperations.h"

@class BATBraveLedger, BATLedgerGrant;
@protocol NativeLedgerBridge;

namespace ledger {
  class NativeLedgerClient : public LedgerClient {
  public:
    NativeLedgerClient(id<NativeLedgerBridge> bridge);
    ~NativeLedgerClient();
    std::unique_ptr<Ledger> ledger;
    
#pragma mark - Obj-C bridge methods/properties
    
    /// Called from `OnRecoverWallet` callback
    std::function<void(const Result, const double, const NSArray<BATLedgerGrant *>*)> walletRecoveredBlock;
    
#pragma mark - LedgerClient methods
    
  private:
    id<NativeLedgerBridge> __weak bridge;
    BATCommonOperations *common;
    
    std::string GenerateGUID() const override;
    /// Called when the user creates a wallet by calling `ledger->CreateWallet()`
    void OnWalletInitialized(Result result) override;
    void OnWalletProperties(Result result, std::unique_ptr<WalletInfo> info) override;
    void OnGrant(Result result, const Grant& grant) override;
    void OnGrantCaptcha(const std::string& image, const std::string& hint) override;
    void OnRecoverWallet(Result result, double balance, const std::vector<Grant>& grants) override;
    void OnReconcileComplete(Result result,
                             const std::string& viewing_id,
                             REWARDS_CATEGORY category,
                             const std::string& probi) override;
    void OnGrantFinish(Result result, const Grant& grant) override;
    void LoadNicewareList(GetNicewareListCallback callback) override;
    void LoadLedgerState(LedgerCallbackHandler* handler) override;
    void LoadPublisherState(LedgerCallbackHandler* handler) override;
    void SaveLedgerState(const std::string& ledger_state, LedgerCallbackHandler* handler) override;
    void SavePublisherState(const std::string& publisher_state, LedgerCallbackHandler* handler) override;
    void SavePublisherInfo(std::unique_ptr<PublisherInfo> publisher_info, PublisherInfoCallback callback) override;
    void LoadPublisherInfo(const std::string& publisher_key, PublisherInfoCallback callback) override;
    void LoadPanelPublisherInfo(ActivityInfoFilter filter, PublisherInfoCallback callback) override;
    void SavePublishersList(const std::string& publishers_list, LedgerCallbackHandler* handler) override;
    void SetTimer(uint64_t time_offset, uint32_t& timer_id) override;
    void LoadPublisherList(LedgerCallbackHandler* handler) override;
    void LoadURL(const std::string& url,
                 const std::vector<std::string>& headers,
                 const std::string& content,
                 const std::string& contentType,
                 const URL_METHOD& method,
                 LoadURLCallback callback) override;
    void OnExcludedSitesChanged(const std::string& publisher_id) override;
    void OnPublisherActivity(Result result, std::unique_ptr<PublisherInfo> info, uint64_t windowId) override;
    void FetchFavIcon(const std::string& url, const std::string& favicon_key, FetchIconCallback callback) override;
    void SaveContributionInfo(const std::string& probi,
                              const int month,
                              const int year,
                              const uint32_t date,
                              const std::string& publisher_key,
                              const REWARDS_CATEGORY category) override;
    void GetRecurringDonations(PublisherInfoListCallback callback) override;
    std::unique_ptr<LogStream> Log(const char* file, int line, LogLevel level) const override;
    void LoadMediaPublisherInfo(const std::string& media_key, PublisherInfoCallback callback) override;
    void SaveMediaPublisherInfo(const std::string& media_key, const std::string& publisher_id) override;
    void FetchWalletProperties() override;
    void FetchGrant(const std::string& lang, const std::string& paymentId) override;
    void GetGrantCaptcha() override;
    std::string URIEncode(const std::string& value) override;
    void SetContributionAutoInclude(const std::string& publisher_key, bool excluded, uint64_t windowId) override;
    void SavePendingContribution(const PendingContributionList& list) override;
    void LoadActivityInfo(ActivityInfoFilter filter, PublisherInfoCallback callback) override;
    void SaveActivityInfo(std::unique_ptr<PublisherInfo> publisher_info, PublisherInfoCallback callback) override;
    void OnRestorePublishers(OnRestoreCallback callback) override;
    void GetActivityInfoList(uint32_t start,
                             uint32_t limit,
                             ActivityInfoFilter filter,
                             PublisherInfoListCallback callback) override;
    void OnRemoveRecurring(const std::string& publisher_key, RecurringRemoveCallback callback) override;
  };
}
