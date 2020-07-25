//
//  LoquyAppTests.swift
//  LoquyAppTests
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import XCTest
@testable import LoquyApp

class LoquyAppTests: XCTestCase {

    func testCannedData() {
        let casts = DummyPodcast.podcasts
        
        XCTAssertEqual(casts.count, 23, "Not equal")
    }
    
//    func testFeed() {
//        
//        var count = Int()
//        var episodess = [Episode]()
//        
//        let exp = XCTestExpectation(description: "Wanda Sykes on cancel culture, UBI, and the 2020 election")
//        
//        ITunesAPI.shared.fetchEpisodes(feedUrl: "https://feeds.megaphone.fm/yang-speaks") { (episodes) in
//            episodess = episodes
//            XCTAssertEqual(episodess[0].title, "Wanda Sykes on cancel culture, UBI, and the 2020 election", "KDJFBKADVBJN")
//        }
//        
////        wait(for:[exp], timeout: 5.0)
//    }

}
