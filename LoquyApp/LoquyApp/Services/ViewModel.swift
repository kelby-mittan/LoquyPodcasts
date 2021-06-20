//
//  PodcastListViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine
import MediaPlayer
import Speech

class ViewModel: ObservableObject {
    
    static let shared = ViewModel()
    
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
    
    @Published var playing = Bool() {
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
    
    
}

class TranscriptionViewModel: ObservableObject {
    
    static let shared = TranscriptionViewModel()
        
    var speechRecognizer = SFSpeechRecognizer()
    
    var didChange = PassthroughSubject<TranscriptionViewModel, Never>()
        
    @Published var startedPlaying = 0 {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var currentTime = TimeText.zero {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var width: CGFloat = 30 {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var transcription = RepText.empty {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var playing = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isTranscribing = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var showAlert = false {
        didSet {
            didChange.send(self)
        }
    }
    
    public func handlePlay(_ audioClip: AudioClip) {
        startedPlaying += 1
        if startedPlaying == 1 {
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) else {
                return
            }

            Player.playAudioClip(url: url)
            playing = true
            
            Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { [weak self] time in
                self?.currentTime = time
            }

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if self.playing {
                    if Player.shared.player.currentItem?.duration.toDisplayString() != TimeText.unloaded && self.width > 0.0 {
                        Player.getCapsuleWidth(width: &self.width, currentTime: self.currentTime)
                    }
                }
            }
        }
    }
    
    public func timeToDisplay() -> String {
        return Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { [weak self] time in
            self?.currentTime = time
        }
    }
    
    public func handleIsTranscribing(_ audioClip: AudioClip) {
        isTranscribing.toggle()
        if isTranscribing {
            handlePlay(audioClip)
            getTranscriptionOfClippedFile(audioClip)
        } else {
            Player.shared.player.pause()
            playing = false
            showAlert.toggle()
        }
    }
    
    public func getTranscriptionOfClippedFile(_ audioClip: AudioClip) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) {
                
                AudioTrim.trimUsingComposition(url: url, start: self.currentTime, duration: audioClip.duration, pathForFile: TrimText.trimmedFile) { (result) in
                    switch result {
                    case .success(let clipUrl):
                        let request = SFSpeechURLRecognitionRequest(url: clipUrl)
                        self.speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, error) in
                            if let error = error {
                                print(ErrorText.recError+error.localizedDescription)
                            } else {
                                if self?.playing == true {
                                    self?.transcription = result?.bestTranscription.formattedString ?? RepText.noTranscription
                                }
                            }
                        })
                    default:
                        break
                    }
                }
            }
        }
    }
    
}

class ControllerViewModel: ObservableObject {
    
    static let shared = ControllerViewModel()
        
    let player = Player.shared.player
        
    var didChange = PassthroughSubject<ControllerViewModel, Never>()
    
    @Published var currentTime = TimeText.zero {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var width: CGFloat = 30 {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var playing = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isPlaying = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var episodePlaying = RepText.empty {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var showAlert = false {
        didSet {
            didChange.send(self)
        }
    }
    
    public func handlePlayPause(_ episode: Episode) {
        if episode.title == episodePlaying {
            !playing ? player.play() : player.pause()
            playing.toggle()
            isPlaying.toggle()
        } else {
            episodePlaying = episode.title
            Player.playEpisode(episode: episode)
            playing = true
        }
    }
    
    public func handlePlayOnAppear(_ episode: Episode) {
        if player.timeControlStatus != .playing {
            episodePlaying = episode.title
            Player.playEpisode(episode: episode)
            if let deepLinkTime = episode.deepLinkTime {
                player.seek(to: deepLinkTime.getCMTime())
            }
            playing = true
            isPlaying = true

        } else {
            Player.getCapsuleWidth(width: &width, currentTime: currentTime)
            if episodePlaying != episode.title {
                playing = false

            }

        }
        Player.getCurrentPlayerTime(currentTime, episode.title == episodePlaying) { [weak self] time in
            self?.currentTime = time
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
            if self.player.timeControlStatus == .playing {
                if self.player.currentItem?.duration.toDisplayString() != TimeText.unloaded && self.width > 0.0 {
                    Player.getCapsuleWidth(width: &self.width, currentTime: self.currentTime)
                    
                }
            }
        }
    }
    
    public func handleTimeDisplayed(_ episode: Episode) -> String {
        return Player.getCurrentPlayerTime(currentTime, episode.title == episodePlaying) { [weak self] ctime in
            self?.currentTime = ctime
        }
    }
    
    public func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playing = true
            self.isPlaying = true
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playing = false
            self.isPlaying = false
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            if Player.shared.player.timeControlStatus == .playing {
                self.player.pause()
            } else {
                self.player.play()
            }
            
            return .success
        }
        
    }
    
}
