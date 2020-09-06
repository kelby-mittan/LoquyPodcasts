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
    
    
    
    func deleteEpisode(episode: Episode) {
        let episodes = savedEpisodes()
        let filteredEpisodes = episodes.filter { $0.title != episode.title }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func getPodcastArt() -> [String] {
        return UserDefaults.standard.object(forKey: UserDefaults.pCastKey) as? [String] ?? []
    }
    
    func setPodcastArt(_ pCasts: [String]) {
        UserDefaults.standard.set(pCasts, forKey: UserDefaults.pCastKey)
    }
    
    func deletePodcastArt(_ pCast: String) {
        let pCasts = getPodcastArt()
        let filteredPCasts = pCasts.filter { $0 != pCast }
        UserDefaults.standard.set(filteredPCasts, forKey: UserDefaults.pCastKey)
    }
}
