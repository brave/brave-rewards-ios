/* WARNING: THIS FILE IS GENERATED. ANY CHANGES TO THIS FILE WILL BE OVERWRITTEN
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "bat/ledger/ledger_client.h"

@protocol NativeLedgerClientBridge;

class NativeLedgerClient : public ledger::LedgerClient {
public:
  NativeLedgerClient(id<NativeLedgerClientBridge> bridge);
  ~NativeLedgerClient();

private:
  id<NativeLedgerClientBridge> __weak bridge_;

  void ConfirmationsTransactionHistoryDidChange() override;
  void FetchFavIcon(const std::string & url, const std::string & favicon_key, ledger::FetchIconCallback callback) override;
  void FetchGrants(const std::string & lang, const std::string & paymentId) override;
  std::string GenerateGUID() const override;
  void GetActivityInfoList(uint32_t start, uint32_t limit, ledger::ActivityInfoFilter filter, ledger::PublisherInfoListCallback callback) override;
  void GetExcludedPublishersNumberDB(ledger::GetExcludedPublishersNumberDBCallback callback) override;
  void GetGrantCaptcha(const std::string & promotion_id, const std::string & promotion_type) override;
  void GetOneTimeTips(ledger::PublisherInfoListCallback callback) override;
  void GetRecurringTips(ledger::PublisherInfoListCallback callback) override;
  void KillTimer(const uint32_t timer_id) override;
  void LoadActivityInfo(ledger::ActivityInfoFilter filter, ledger::PublisherInfoCallback callback) override;
  void LoadLedgerState(ledger::LedgerCallbackHandler * handler) override;
  void LoadMediaPublisherInfo(const std::string & media_key, ledger::PublisherInfoCallback callback) override;
  void LoadNicewareList(ledger::GetNicewareListCallback callback) override;
  void LoadPanelPublisherInfo(ledger::ActivityInfoFilter filter, ledger::PublisherInfoCallback callback) override;
  void LoadPublisherInfo(const std::string & publisher_key, ledger::PublisherInfoCallback callback) override;
  void LoadPublisherList(ledger::LedgerCallbackHandler * handler) override;
  void LoadPublisherState(ledger::LedgerCallbackHandler * handler) override;
  void LoadState(const std::string & name, ledger::OnLoadCallback callback) override;
  void LoadURL(const std::string & url, const std::vector<std::string> & headers, const std::string & content, const std::string & contentType, const ledger::URL_METHOD method, ledger::LoadURLCallback callback) override;
  std::unique_ptr<ledger::LogStream> Log(const char * file, int line, const ledger::LogLevel log_level) const override;
  void OnExcludedSitesChanged(const std::string & publisher_id, ledger::PUBLISHER_EXCLUDE exclude) override;
  void OnGrant(ledger::Result result, const ledger::Grant & grant) override;
  void OnGrantCaptcha(const std::string & image, const std::string & hint) override;
  void OnGrantFinish(ledger::Result result, const ledger::Grant & grant) override;
  void OnPanelPublisherInfo(ledger::Result result, std::unique_ptr<ledger::PublisherInfo> arg1, uint64_t windowId) override;
  void OnReconcileComplete(ledger::Result result, const std::string & viewing_id, ledger::REWARDS_CATEGORY category, const std::string & probi) override;
  void OnRecoverWallet(ledger::Result result, double balance, const std::vector<ledger::Grant> & grants) override;
  void OnRemoveRecurring(const std::string & publisher_key, ledger::RecurringRemoveCallback callback) override;
  void OnRestorePublishers(ledger::OnRestoreCallback callback) override;
  void OnWalletInitialized(ledger::Result result) override;
  void OnWalletProperties(ledger::Result result, std::unique_ptr<ledger::WalletInfo> arg1) override;
  void ResetState(const std::string & name, ledger::OnResetCallback callback) override;
  void SaveActivityInfo(std::unique_ptr<ledger::PublisherInfo> publisher_info, ledger::PublisherInfoCallback callback) override;
  void SaveContributionInfo(const std::string & probi, const int month, const int year, const uint32_t date, const std::string & publisher_key, const ledger::REWARDS_CATEGORY category) override;
  void SaveLedgerState(const std::string & ledger_state, ledger::LedgerCallbackHandler * handler) override;
  void SaveMediaPublisherInfo(const std::string & media_key, const std::string & publisher_id) override;
  void SaveNormalizedPublisherList(const ledger::PublisherInfoListStruct & normalized_list) override;
  void SavePendingContribution(const ledger::PendingContributionList & list) override;
  void SavePublisherInfo(std::unique_ptr<ledger::PublisherInfo> publisher_info, ledger::PublisherInfoCallback callback) override;
  void SavePublisherState(const std::string & publisher_state, ledger::LedgerCallbackHandler * handler) override;
  void SavePublishersList(const std::string & publisher_state, ledger::LedgerCallbackHandler * handler) override;
  void SaveState(const std::string & name, const std::string & value, ledger::OnSaveCallback callback) override;
  void SetConfirmationsIsReady(const bool is_ready) override;
  void SetTimer(uint64_t time_offset, uint32_t * timer_id) override;
  std::string URIEncode(const std::string & value) override;
  std::unique_ptr<ledger::LogStream> VerboseLog(const char * file, int line, int vlog_level) const override;
};
