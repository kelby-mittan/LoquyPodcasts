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
    var feedUrl: String?
    var deepLinkTime: String?
    
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
        if let url = url {
            let urlString = url.absoluteString
            let components = urlString.components(separatedBy: "loquyAppEpisode")
            
            title = components[1].removingPercentEncoding ?? "No Title"
            pubDate = Date()
            description = components[2].removingPercentEncoding ?? "No Description"
            author = components[3].removingPercentEncoding ?? "No Author"
            streamUrl = components[4]
            imageUrl = components[5]
            deepLinkTime = components[6]
        } else {
            title = "Error"
            pubDate = Date()
            description = "Error"
            author = ""
            streamUrl = ""
            imageUrl = ""
        }
    }
}
