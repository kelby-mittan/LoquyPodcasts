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
}
