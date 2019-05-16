/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest
@testable import BraveRewards

let stateStoragePath = NSSearchPathForDirectoriesInDomains(
  .documentDirectory,
  .userDomainMask,
  true
  ).first!.appending("/brave_ads");

class BraveRewardsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Purge the persistant storage directory
    try? FileManager.default.removeItem(atPath: stateStoragePath)
    
    BraveAds.isTesting = true
    BraveAds.isDebug = true
    BraveAds.isProduction = false
  }
  
  func testDisabledByDefault() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let ads = BraveAds(stateStoragePath: stateStoragePath)
    XCTAssertFalse(ads.isEnabled, "Brave Ads should be disabled by default")
  }
  
  func testEnabledAtCreation() {
    let ads = BraveAds(stateStoragePath: stateStoragePath, enabled: true)
    XCTAssertTrue(ads.isEnabled, "Brave Ads was enabled at creation")
  }
  
  func testSupportedLocales() {
    // Should support all the locales in the `locales` directory
    let supportedLocales = BraveAds(stateStoragePath: stateStoragePath).supportedLocales
    guard let localesPath = Bundle(for: BraveAds.self).path(forResource: "locales", ofType: nil) else {
      XCTFail("Could not locate locales path in bundle")
      return
    }
    let contents = try! FileManager.default.contentsOfDirectory(atPath: localesPath)
    XCTAssertEqual(Set<String>(contents), Set<String>(supportedLocales))
  }
  
  func testServingSampleAd() {
    let expect = expectation(description: "Serving Sample Ad")
    
    let ads = BraveAds(stateStoragePath: stateStoragePath, enabled: true)
    
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
