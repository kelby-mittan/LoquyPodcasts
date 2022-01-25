//
//  ITunesAPI.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class ITunesAPI {
    
    static let shared = ITunesAPI()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let baseiTunesSearchURL = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let _ = dataResponse.error {
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                if let error = result.error {
                    print("error parsing: \(error)")
                    return
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
            })
        }
    }
    
    func fetchSpecificEpisode(feedUrl: String, date: String, completionHandler: @escaping (Episode) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                if let error = result.error {
                    print("error parsing: \(error)")
                    return
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                let episode = episodes.filter {$0.pubDate.description == date}.first
                guard let validEpisode = episode else { return }
                
                completionHandler(validEpisode)
                
            })
        }
    }
}
