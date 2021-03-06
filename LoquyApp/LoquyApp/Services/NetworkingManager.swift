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

class ViewModel: ObservableObject {
    
    var didChange = PassthroughSubject<ViewModel, Never>()
    
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
    
    @Published var favorites = [Episode]() {
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
    
    @Published var loquys = [Loquy]() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var episodePlaying = String() {
        didSet {
            didChange.send(self)
        }
    }
    
    public func updatePodcasts(forSearch: String) {
        ITunesAPI.shared.fetchPodcasts(searchText: forSearch) { [weak self] (podcasts) in
            DispatchQueue.main.async {
                self?.podcasts = podcasts
            }
        }
    }
    
    public func loadEpisodes(feedUrl: String) {
        ITunesAPI.shared.fetchEpisodes(feedUrl: feedUrl) { [weak self] (episodes) in
            DispatchQueue.main.async {
                self?.episodes = episodes
            }
        }
    }
    
    public func loadFavorites() {
        do {
            favorites = try Persistence.episodes.loadItems()
        } catch {
            print("error getting favorites: \(error)")
        }
    }
    
    public func loadTimeStamps(for episode: Episode) {
        do {
            let timeStamps = try Persistence.timeStamps.loadItems().filter { $0.episode == episode }.map { $0.time }
            DispatchQueue.main.async {
                self.timeStamps = timeStamps
            }
        } catch {
            print("error with timestamps: \(error)")
        }
    }
    
    public func loadAudioClips() {
        do {
            let audioClips = try Persistence.audioClips.loadItems()
            DispatchQueue.main.async {
                self.audioClips = audioClips.reversed()
            }
        } catch {
            print("error getting clips: \(error)")
        }
    }
    
    public func loadLoquys() {
        do {
            let loquys = try Persistence.loquys.loadItems()
            DispatchQueue.main.async {
                self.loquys = loquys.reversed()
            }
        } catch {
            print("error getting transcriptions: \(error)")
        }
    }
    
    public func getFavoriteEpisodes(_ title: inout String) -> [Episode] {
        var episodes: [Episode] = []
        do {
            episodes = try Persistence.episodes.loadItems().filter { $0.author == title }
        } catch {
            print("error getting episodes: \(error)")
        }
        title = episodes.first?.author ?? ""
        return episodes
    }
    
}
