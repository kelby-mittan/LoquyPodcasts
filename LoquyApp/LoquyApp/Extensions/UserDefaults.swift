//
//  UserDefaults.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoriteKey = "favoriteKey"
    static let pCastKey = "pCastKey"
    
    func savedEpisodes() -> [Episode] {
        guard let episodesData = data(forKey: UserDefaults.favoriteKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("Could not decode:", decodeErr)
        }
        
        return []
    }
    
    func saveTheEpisode(episode: Episode) {
            do {
                var episodes = savedEpisodes()
                episodes.insert(episode, at: 0)
                let data = try JSONEncoder().encode(episodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
                
            } catch let encodeErr {
                print("Could not encode episode:", encodeErr)
            }
        }
    
    func deletePodcast(episode: Episode) {
        let episodes = savedEpisodes()
        
        let filteredEpisodes = episodes.filter { (eps) -> Bool in
            return eps.id != episode.id && eps.description != episode.description
        }
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: filteredEpisodes, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
    }
    
}
