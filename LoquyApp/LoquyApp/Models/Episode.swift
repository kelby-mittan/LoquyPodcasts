//
//  Episode.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable, Identifiable, Hashable {
    
    var id: UUID?
    var title: String
    var pubDate: Date
    var description: String
    var author: String
    var streamUrl: String
    var fileUrl: String?
    var imageUrl: String?
    var timeStamp: Int64?
    
    init(feedItem: RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}

extension Episode {
    init(url: URL?) {
//        guard let url = url else { fatalError() }
        title = ""
        pubDate = Date()
        description = ""
        author = ""
        streamUrl = ""
        imageUrl = ""
    }
}
