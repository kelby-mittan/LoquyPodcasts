//
//  Player.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer
import SwiftUI

class Player {
    
    static var shared = Player()
    
    public var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    public var isPlaying: Bool = {
        let playing = Bool()
        return playing
    }()
    
    static func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }
    
    static func playEpisodeUsingFileUrl(episode: Episode) {
        guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        trueLocation.appendPathComponent(fileName)
        let playerItem = AVPlayerItem(url: trueLocation)
        Player.shared.player.replaceCurrentItem(with: playerItem)
        Player.shared.player.play()
    }
    
    static func playEpisode(episode: Episode) {
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl(episode: episode)
        } else {
            guard let url = URL(string: episode.streamUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            Player.shared.player.replaceCurrentItem(with: playerItem)
            Player.shared.player.play()
        }
    }
    
    static func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(Player.shared.player.currentTime(), fifteenSeconds)
        Player.shared.player.seek(to: seekTime)
    }
    
    static func playAudioClip(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        Player.shared.player.replaceCurrentItem(with: playerItem)
        Player.shared.player.play()
    }
    
    /// Function determines the AVPlayer's current playing time and its percentage of the full podcast duration
    /// - Returns: CGFloat representing where the Capsule should be on the screen
    static func updateTimeCapsule() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(Player.shared.player.currentTime())
        let durationSeconds = CMTimeGetSeconds(Player.shared.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
    /// Function determines where to seek to within a podcast based on a capsule drag
    /// - Parameter xVal: CGFloat determined from a Capsules x location
    /// - Returns: A CMTime to be used when seeking a certain time in a podcast
    @discardableResult
    static func capsuleDragged(_ xVal: CGFloat) -> CMTime {
        //        let x = value.location.x
        let screen = UIScreen.main.bounds.width - 30
        let percentage = xVal / screen
        
        guard let duration = Player.shared.player.currentItem?.duration else { return CMTime(value: 0, timescale: 0) }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        return seekTime
    }
    
    static func getCapsuleWidth(width: inout CGFloat, currentTime: String) {
        let screen = UIScreen.main.bounds.width - 30
        let duration = Player.shared.player.currentItem?.duration.toDisplayString() ?? "00:00:00"
        let percent = currentTime.toSecDouble() / duration.toSecDouble()
        width = screen * CGFloat(percent) + 20
    }
    
    @discardableResult
    static func getCurrentPlayerTime(currentTime: inout String) -> (cTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        var timeStr = "--:--"
        Player.shared.player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            timeStr = time.toDisplayString()
        }
        currentTime = timeStr
        guard let durationTime = Player.shared.player.currentItem?.duration else {
            return ("--:--", "--:--")
        }
        let dt = durationTime - currentTime.getCMTime()
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }
    
    
}
