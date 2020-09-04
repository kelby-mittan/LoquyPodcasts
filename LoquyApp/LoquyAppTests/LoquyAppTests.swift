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

    // https://traffic.omny.fm/d/clips/aaea4e69-af51-495e-afc9-a9760146922b/43816ad6-9ef9-4bd5-9694-aadc001411b2/de583063-feb2-4fae-9812-ac280122dd3e/audio.mp3?utm_source=Podcast&in_playlist=808b901f-5d31-4eb8-91a6-aadc001411c0
    
    // https://rss.art19.com/sean-carrolls-mindscape
    
    func testLoadEpisodes() {
        ITunesAPI.shared.fetchEpisodes(feedUrl: "https://rss.art19.com/sean-carrolls-mindscape") { (episodes) in
            XCTAssertEqual(episodes.first?.fileUrl, "https://dts.podtrac.com/redirect.mp3/chtbl.com/track/9EE2G/pdst.fm/e/rss.art19.com/episodes/0150d3bf-787a-48aa-a698-ad0020a41b0a.mp3", "File Urls")
        }
    }
}
