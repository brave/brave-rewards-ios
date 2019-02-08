//
//  BraveRewardsTests.swift
//  BraveRewardsTests
//
//  Created by Kyle Hickinson on 2019-01-09.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

import XCTest
@testable import BraveRewards

class BraveRewardsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Purge the persistant storage directory
    if let directory = NSSearchPathForDirectoriesInDomains(
      .documentDirectory,
      .userDomainMask,
      true
      ).first?.appending("/brave_ads") {
      try? FileManager.default.removeItem(atPath: directory)
    }
  }
  
  func testDisabledByDefault() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let ads = BraveAds(appVersion: "1.0")
    XCTAssertFalse(ads.isEnabled, "Brave Ads should be disabled by default")
  }
  
  func testEnabledAtCreation() {
    let ads = BraveAds(appVersion: "1.0", enabled: true)
    XCTAssertTrue(ads.isEnabled, "Brave Ads was enabled at creation")
  }
  
  func testSupportedLocales() {
    // Should support all the locales in the `locales` directory
    let supportedLocales = BraveAds(appVersion: "1.0").supportedLocales
    guard let localesPath = Bundle(for: BraveAds.self).path(forResource: "locales", ofType: nil) else {
      XCTFail("Could not locate locales path in bundle")
      return
    }
    let contents = try! FileManager.default.contentsOfDirectory(atPath: localesPath)
    XCTAssertEqual(Set<String>(contents), Set<String>(supportedLocales))
  }
  
  func testServingSampleAd() {
    let expect = expectation(description: "Serving Sample Ad")
    
    let ads = BraveAds(appVersion: "1.0", enabled: true)
    
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
