// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import BraveRewards

struct DataLoader {
  static func loadContent(rewards: BraveRewards) {
    
    func report(site: (String, Int), tab: Int) {
      let url = URL(string: site.0)!
      rewards.reportLoadedPage(url: url, faviconUrl: nil, tabId: UInt32(tab), html: "<html><body>hjabsd</body></html>", shouldClassifyForAds: true)
      rewards.reportTabUpdated(tab, url: url, faviconURL: nil, isSelected: true, isPrivate: false)
      
    }
    let sites: [(String, Int)] = [
      ("https://bumpsmack.com", 12),
      ("https://myetherwallet.com", 14),
      ("https://theverge.com", 15),
      ("https://reddit.com", 20),
      ("https://amazon.com", 11),
      ("https://google.com", 16),
      ("https://yahoo.com", 21),
      ("https://brave.com", 35),
      ("https://facebook.com", 80),
      ("https://youtube.com", 85),
      ("https://vimeo.com", 90),
      ("https://twitch.com", 15),
      ("https://twitter.com", 25),
      ("https://live.com", 55),
      ("https://wikipedia.com", 55),
      ("https://abc.com", 25)
    ]
    var duration: Int = 0
    for (i, site) in sites.enumerated() {
      duration += i == 0 ? 0 : sites[i - 1].1
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
        report(site: site, tab: i + 1)
      }
    }
  }
}
