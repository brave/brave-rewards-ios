/* Copyright (c) 2019 The Brave Authors. All rights reserved.
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef BAT_LEDGER_REWARDS_INTERNALS_INFO_H_
#define BAT_LEDGER_REWARDS_INTERNALS_INFO_H_

#include <map>
#include <string>

namespace ledger {

struct ReconcileInfo;

LEDGER_EXPORT struct RewardsInternalsInfo {
  RewardsInternalsInfo();
  ~RewardsInternalsInfo();
  RewardsInternalsInfo(const RewardsInternalsInfo& info);

  const std::string ToJson() const;
  bool loadFromJson(const std::string& json);

  std::string payment_id;
  bool is_key_info_seed_valid;
  std::string persona_id;
  std::string user_id;
  uint64_t boot_stamp;

  std::map<std::string, ReconcileInfo> current_reconciles;
};

}  // namespace ledger

#endif  // BAT_LEDGER_REWARDS_INTERNALS_INFO_H_
