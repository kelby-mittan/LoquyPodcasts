//
//  Podcast.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct Podcast: Decodable, Hashable {
        
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
