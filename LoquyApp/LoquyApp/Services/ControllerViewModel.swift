//
//  ControllerViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/19/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine
import MediaPlayer

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
