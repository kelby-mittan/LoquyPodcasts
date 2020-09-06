//
//  Player.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import AVKit
//import MediaPlayer

struct Player {
    
    static func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }
    
    static func playEpisodeUsingFileUrl(episode: Episode, player: AVPlayer) {
        print("Attempt to play episode with file url:", episode.fileUrl ?? "")
        
        guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        trueLocation.appendPathComponent(fileName)
        print("True Location of episode:", trueLocation.absoluteString)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    static func playEpisode(episode: Episode, player: AVPlayer) {
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl(episode: episode, player: player)
        } else {
            print("Trying to play episode at url:", episode.streamUrl)
            
            print("EPISODE STREAM URL: \(episode.streamUrl)")
            guard let url = URL(string: episode.streamUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    static func seekToCurrentTime(delta: Int64, player: AVPlayer) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    static func playAudioClip(url: URL, player: AVPlayer) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}
