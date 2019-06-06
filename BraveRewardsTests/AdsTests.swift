/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest
@testable import BraveRewards

let stateStoragePath = NSTemporaryDirectory().appending("com.brave.rewards.ads");

class BraveRewardsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    BraveAds.isTesting = true
    BraveAds.isDebug = true
    BraveAds.isProduction = false
  }
  
  override func tearDown() {
    super.tearDown()
    
    // Purge the persistant storage directory
    try? FileManager.default.removeItem(atPath: stateStoragePath)
  }
  
  func testEnabledByDefault() {
    let ads = BraveAds(stateStoragePath: stateStoragePath)
    XCTAssertTrue(ads.isEnabled, "Brave Ads should be enabled by default on iOS")
  }
  
  func testPreferencePersistance() {
    let expect = expectation(description: "File IO")
    
    let ads = BraveAds(stateStoragePath: stateStoragePath)
    ads.isEnabled = false
    ads.adsPerDay = 10
    ads.adsPerHour = 6
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      let secondAds = BraveAds(stateStoragePath: stateStoragePath)
      XCTAssertEqual(ads.isEnabled, secondAds.isEnabled)
      XCTAssertEqual(ads.adsPerDay, secondAds.adsPerDay)
      XCTAssertEqual(ads.adsPerHour, secondAds.adsPerHour)
      
      expect.fulfill()
    }
    
    wait(for: [expect], timeout: 4.0)
  }
  
  func testServingSampleAd() {
    let expect = expectation(description: "Serving Sample Ad")
    
    let ads = BraveAds(stateStoragePath: stateStoragePath)
    
    let delegate = MockAdsDelegate()
    delegate.showNotification = { notification in
      defer { expect.fulfill() }
      return true
    }
    ads.delegate = delegate
    ads.serveSampleAd()
    waitForExpectations(timeout: 5.0, handler: nil)
  }
}

class MockAdsDelegate: NSObject, BraveAdsDelegate {
  var showNotification: ((AdsNotification) -> Bool)?
  
  func braveAds(_ braveAds: BraveAds, show notification: AdsNotification) -> Bool {
    return self.showNotification?(notification) ?? false
  }
}
