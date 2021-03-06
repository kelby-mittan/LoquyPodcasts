//
//  UserDefaults.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/5/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

//extension UserDefaults {
//    
//    static let favoriteKey = "favoriteKey"
//    static let pCastKey = "pCastKey"
//    static let timeStampKey = "timeStampKey"
//    static let clipsKey = "clipsKey"
//    
//    func savedEpisodes() -> [Episode] {
//        guard let episodesData = data(forKey: UserDefaults.favoriteKey) else { return [] }
//        
//        do {
//            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
//            return episodes
//        } catch let decodeErr {
//            print("Could not decode:", decodeErr)
//        }
//        
//        return []
//    }
//    
//    func saveTheEpisode(episode: Episode) {
//        do {
//            var episodes = savedEpisodes()
//            episodes.insert(episode, at: 0)
//            let data = try JSONEncoder().encode(episodes)
//            UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
//            
//        } catch let encodeErr {
//            print("Could not encode episode:", encodeErr)
//        }
//    }
//    
//    
//    
//    func deleteEpisode(episode: Episode) {
//        let episodes = savedEpisodes()
//        let filteredEpisodes = episodes.filter { $0.title != episode.title }
//        
//        do {
//            let data = try JSONEncoder().encode(filteredEpisodes)
//            UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
//        } catch let encodeErr {
//            print("Failed to encode episode:", encodeErr)
//        }
//    }
//    
//    func getPodcastArt() -> [String] {
//        return UserDefaults.standard.object(forKey: UserDefaults.pCastKey) as? [String] ?? []
//    }
//
//    func setPodcastArt(_ pCasts: [String]) {
//        UserDefaults.standard.set(pCasts, forKey: UserDefaults.pCastKey)
//    }
//
//    func deletePodcastArt(_ pCast: String) {
//        let pCasts = getPodcastArt()
//        let filteredPCasts = pCasts.filter { $0 != pCast }
//        UserDefaults.standard.set(filteredPCasts, forKey: UserDefaults.pCastKey)
//    }
//
//    func savedTimeStamps() -> [TimeStamp] {
//        guard let stampsData = data(forKey: UserDefaults.timeStampKey) else { return [] }
//
//        do {
//            let stamps = try JSONDecoder().decode([TimeStamp].self, from: stampsData)
//            return stamps
//        } catch let decodeErr {
//            print("Could not decode:", decodeErr)
//        }
//
//        return []
//    }
//
//    func saveTheTimeStamp(timeStamp: TimeStamp) {
//        do {
//            var stamps = savedTimeStamps()
//            stamps.insert(timeStamp, at: 0)
//            let data = try JSONEncoder().encode(stamps)
//            UserDefaults.standard.set(data, forKey: UserDefaults.timeStampKey)
//
//        } catch let encodeErr {
//            print("Could not encode time stamp:", encodeErr)
//        }
//    }
//
//    func deleteTimeStamp(timeStamp: TimeStamp) {
//        let stamps = savedTimeStamps()
//        let filteredStamps = stamps.filter { $0.time != timeStamp.time && $0.episode == timeStamp.episode }
//
//        do {
//            let data = try JSONEncoder().encode(filteredStamps)
//            UserDefaults.standard.set(data, forKey: UserDefaults.timeStampKey)
//        } catch let encodeErr {
//            print("Failed to encode time stamp:", encodeErr)
//        }
//    }
//    
//    func savedAudioClips() -> [AudioClip] {
//        guard let audioClipsData = data(forKey: UserDefaults.clipsKey) else { return [] }
//        
//        do {
//            let clips = try JSONDecoder().decode([AudioClip].self, from: audioClipsData)
//            return clips
//        } catch let decodeErr {
//            print("Could not decode:", decodeErr)
//        }
//        
//        return []
//    }
//    
//    func saveTheClip(clip: AudioClip) {
//        do {
//            var clips = savedAudioClips()
//            clips.insert(clip, at: 0)
//            let data = try JSONEncoder().encode(clips)
//            UserDefaults.standard.set(data, forKey: UserDefaults.clipsKey)
//            
//        } catch let encodeErr {
//            print("Could not encode audio clip:", encodeErr)
//        }
//    }
//    
//    func deleteAudioClip(clip: AudioClip) {
//        let clips = savedAudioClips()
//        let filteredClips = clips.filter { $0.startTime != clip.startTime }
//        
//        do {
//            let data = try JSONEncoder().encode(filteredClips)
//            UserDefaults.standard.set(data, forKey: UserDefaults.clipsKey)
//        } catch let encodeErr {
//            print("Failed to encode audio clip:", encodeErr)
//        }
//    }
//}
