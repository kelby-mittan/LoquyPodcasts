//
//  PodcastListViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class NetworkingManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkingManager, Never>()
    
    @Published var podcasts = [Podcast]() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var episodes = [Episode]() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isShowAlert = Bool() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var timeStamps = [String]() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var audioClips = [AudioClip]() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var hideTabBar = Bool() {
        didSet {
            didChange.send(self)
        }
    }
    
    func updatePodcasts(forSearch: String) {
        ITunesAPI.shared.fetchPodcasts(searchText: forSearch) { (podcasts) in
            DispatchQueue.main.async {
                self.podcasts = podcasts
            }
        }
    }
    
    func loadEpisodes(feedUrl: String) {
        ITunesAPI.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            DispatchQueue.main.async {
                self.episodes = episodes
            }
        }
    }
    
    func loadTimeStamps(for episode: Episode) {
        
        do {
            let timeStamps = try Persistence.timeStamps.loadItems().filter { $0.episode == episode }.map { $0.time }
            DispatchQueue.main.async {
                self.timeStamps = timeStamps
            }
        } catch {
            print("error with timestamps: \(error)")
        }
        
//        let timeStamps = UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
//        DispatchQueue.main.async {
//            self.timeStamps = timeStamps
//        }
    }
    
    func loadAudioClips() {
        do {
            let audioClips = try Persistence.audioClips.loadItems()
            DispatchQueue.main.async {
                self.audioClips = audioClips.reversed()
            }
        } catch {
            print("error getting clips: \(error)")
        }
    }
    
    func hideTheTabBar() {
        self.hideTabBar = true
    }
}
