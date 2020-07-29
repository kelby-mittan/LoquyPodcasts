//
//  Podcast.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct Podcast: Decodable, Identifiable, Hashable {
    
    var id: UUID?
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    var genres: [String]?
}

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
