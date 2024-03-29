//
//  Player.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import MediaPlayer
import SwiftUI

class Player {
    
    static var shared = Player()
    
    public var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        return avPlayer
    }()
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print(ErrorText.activatingSesh, sessionErr)
        }
    }
    
    static func playEpisode(episode: Episode) {
        
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        shared.player.replaceCurrentItem(with: playerItem)
        
        shared.player.play()
    }
    
    static func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(Player.shared.player.currentTime(), fifteenSeconds)
        shared.player.seek(to: seekTime)
    }
    
    static func playAudioClip(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        shared.player.replaceCurrentItem(with: playerItem)
        shared.player.play()
    }
    
    /// Function determines the AVPlayer's current playing time and its percentage of the full podcast duration
    /// - Returns: CGFloat representing where the Capsule should be on the screen
    static func updateTimeCapsule() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(shared.player.currentTime())
        let durationSeconds = CMTimeGetSeconds(shared.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
    /// Function determines where to seek to within a podcast based on a capsule drag
    /// - Parameter xVal: CGFloat determined from a Capsules x location
    /// - Returns: A CMTime to be used when seeking a certain time in a podcast
    @discardableResult
    static public func capsuleDragged(_ xVal: CGFloat) -> CMTime {
        let screen = UIScreen.main.bounds.width - 30
        let percentage = xVal / screen
        
        guard let duration = shared.player.currentItem?.duration else { return CMTime(value: 0, timescale: 0) }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        return seekTime
    }
    
    /// Function calculates and updates the width for a capsule view depending on the current player time
    /// - Parameter width: CGFloat of the width of a capsule that will be updated
    /// - Parameter currentTime: String for the current time being played of a podcast
    static public func getCapsuleWidth(width: inout CGFloat, currentTime: String) {
        let screen = UIScreen.main.bounds.width - 20
        let duration = shared.player.currentItem?.duration.toDisplayString() ?? "00:00:00"
        let percent = currentTime.toSecDouble() / duration.toSecDouble()
        width = screen * CGFloat(percent) + 20
    }
    
    /// Function gets the current time for a podcast being played using a completion handler
    /// - Parameter currentTime: String for current time of podcast being played
    /// - Parameter ctCondition: Bool for a current time condition to be met to display a new string for start time, otherwise start from 00:00:00
    /// - Parameter completion: Closure for capturing the start time of a clip or podcast
    /// - Returns: A discardable result for the length of a clip or podcast
    @discardableResult
    static public func getCurrentPlayerTime(_ currentTime: String, _ ctCondition: Bool, completion: @escaping (String) -> ()) -> (String) {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        shared.player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            if ctCondition {
                completion(time.toDisplayString())
            } else {
                completion("00:00:00")
            }
            
        }
        guard let durationTime = Player.shared.player.currentItem?.duration else {
            return ("--:--")
        }
        let dt = durationTime - currentTime.getCMTime()
        durationLabel = "-" + dt.toDisplayString()
        return durationLabel
    }
    
    static public func handleWidth(_ value: DragGesture.Value,
                                   _ width: inout CGFloat,
                                   _ currentTime: inout String) {
        
        let x = value.location.x
        let maxVal = UIScreen.main.bounds.width - 30
        let minVal: CGFloat = 10
        
        if x < minVal {
            width = minVal
        } else if x > maxVal {
            width = maxVal
        } else {
            width = x
        }
        currentTime = capsuleDragged(value.location.x).toDisplayString()
    }
    
}
