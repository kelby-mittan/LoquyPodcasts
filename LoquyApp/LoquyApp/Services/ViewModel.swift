//
//  PodcastListViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
        
    var didChange = PassthroughSubject<ViewModel, Never>()
    var domColorReporter = PassthroughSubject<UIColor?, Never>()
    
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
    
    @Published var playing = Bool() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var imageColor: UIColor? = nil {
        didSet {
            if imageColor != nil {
                didChange.send(self)
            }
        }
    }
    
    @Published var clipDomColor: UIColor? = nil {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var episodeDomColor: Episode? {
        didSet {
            didChange.send(self)
        }
    }
    
    public func loadSearchPodcasts(search: String) {
        var timer: Timer?
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { (_) in
            self.updatePodcasts(forSearch: search)
        })
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
            print(error.localizedDescription)
        }
    }
    
    public func loadTimeStamps(for episode: Episode) {
        do {
            let timeStamps = try Persistence.timeStamps.loadItems().filter { $0.episode == episode }.map { $0.time }
            DispatchQueue.main.async {
                self.timeStamps = timeStamps
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func loadAudioClips() {
        do {
            let audioClips = try Persistence.audioClips.loadItems()
            DispatchQueue.main.async {
                self.audioClips = audioClips.reversed()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func loadLoquys() {
        do {
            let loquys = try Persistence.loquys.loadItems()
            DispatchQueue.main.async {
                self.loquys = loquys.reversed()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func loadFavoriteEpisodes(_ title: inout String) -> [Episode] {
        var episodes: [Episode] = []
        do {
            episodes = try Persistence.episodes.loadItems().filter { $0.author == title }
        } catch {
            print(error.localizedDescription)
        }
        title = episodes.first?.author ?? RepText.empty
        return episodes
    }
    
    public func handleIsPlaying() {
        self.playing = Player.shared.player.timeControlStatus == .playing
    }
    
    public func getEpisodeForDomColor() {
        guard let episode = episodes.first else {
            return
        }
//        self.episodeDomColor = episode
        
        getDomColor(episode.imageUrl ?? RepText.empty) { [weak self] clr in
            DispatchQueue.main.async {
                self?.imageColor = clr
            }
        }
    }
    
    public func getDomColor(_ urlStr: String, completion: @escaping (UIColor) -> ()) {
        guard let url = URL(string: urlStr) else { return }
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data), let clr = image.averageColor {
                    completion(clr)
            }
        }
    }
}
