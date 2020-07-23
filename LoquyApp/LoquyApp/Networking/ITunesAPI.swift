//
//  ITunesAPI.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import Alamofire

class ITunesAPI {
    
    static let shared = ITunesAPI()
    
    func getPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(searchText)&entity=podcast"
        AF.request(url).response { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact Yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(searchResult.results)
                }
                
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func loadPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ())  {
        
        let text = searchText.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)&entity=podcast") else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let results = try? JSONDecoder().decode(SearchResults.self, from: data)
                let podcasts = results?.results
                DispatchQueue.main.async {
                    completionHandler(podcasts ?? [])
                }
            }
        }.resume()
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let baseiTunesSearchURL = "https://itunes.apple.com/search"
        
        print("Searching for podcasts...")
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact iTunes", err)
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
}
