//
//  ControlView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 8/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit
import MediaPlayer
import AVFoundation

struct ControlView: View {
    
    let episode: Episode
    
    @State var width : CGFloat = 30
    @State var playing = true
    @State var isFirstPlay = false
    @State var currentTime: String = "0:00"
    @State var isRecording = false
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private var audioRecorder: AVAudioRecorder!
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                            let x = value.location.x
                            let maxVal = UIScreen.main.bounds.width - 10
                            let minVal: CGFloat = 10
                            
                            if x < minVal {
                                self.width = minVal
                            } else if x > maxVal {
                                self.width = maxVal
                            } else {
                                self.width = x
                            }
                            
                            print("width val is : \(self.width)")
                            
                            
                            
                        }).onEnded({ (value) in
                            
                            let x = value.location.x
                            
                            let screen = UIScreen.main.bounds.width - 30
                            
                            let percentage = x / screen
                            
                            guard let duration = self.player.currentItem?.duration else { return }
                            let durationInSeconds = CMTimeGetSeconds(duration)
                            let seekTimeInSeconds = Float64(percentage) * durationInSeconds
                            let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
                            
                            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
                            
                            self.player.seek(to: seekTime)
                            
                            print(seekTime)
                            
                        }))
                    .padding([.top,.leading,.trailing])
                
            }
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(observePlayerCurrentTime().durationTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding([.leading,.trailing])
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
                
                Button(action: {
                    self.seekToCurrentTime(delta: -15)
                }) {
                    Image(systemName: "gobackward.15").font(.largeTitle)
                }
                
                Button(action: {
                    self.playing.toggle()
                    self.playing ? self.player.play() : self.player.pause()
                    
                }) {
                    Image(systemName: self.playing ? "pause.fill" : "play.fill").font(.largeTitle)
                }
                
                Button(action: {
                    self.seekToCurrentTime(delta: 15)
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            Button(action: {
                self.isRecording.toggle()
                
                if self.isRecording {
                    
                }
            }) {
                Image(systemName: "recordingtape").font(.largeTitle)
            }
            .padding(.top,25)
        }.onAppear {
            self.playEpisode()
            self.observePlayerCurrentTime()
            
            print(self.episode.fileUrl ?? "error")
        }
    }
    
    private func playEpisode() {
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            print("Trying to play episode at url:", episode.streamUrl)
            
            guard let url = URL(string: episode.streamUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }
    
    private func playEpisodeUsingFileUrl() {
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
    
    @discardableResult
    private func observePlayerCurrentTime() -> (currentTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTime = time.toDisplayString()
        }
        let durationTime = self.player.currentItem?.duration
        guard let dt = durationTime else { return ("0:00","0:00") }
        durationLabel = dt.toDisplayString()
        return (currentTime,durationLabel)
    }
    
    private func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    mutating func startRecording() {
        guard let newFileURL = createURLForNewRecord() else {
            print("Error")
            return
        }
        
        do {
            
            //                var urlString = URL(string: newFileURL)
            //                urlString = newFileURL
            audioRecorder = try AVAudioRecorder(url: newFileURL,
                                                settings: [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
                                                           AVSampleRateKey: 8000,
                                                           AVNumberOfChannelsKey: 1,
                                                           AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue])
            //                audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record(forDuration: 60)
        } catch {
            print("RECORDING ERROR: \(error)")
        }
        
    }
    
    private func createURLForNewRecord() -> URL? {
        guard let appGroupFolderUrl = FileManager.getAppFolderURL() else {
            return nil
        }
        
        let date = String(describing: Date())
        let fullFileName = "LoquyClip" + date + ".m4a"
        let newRecordFileName = appGroupFolderUrl.appendingPathComponent(fullFileName)
        return newRecordFileName
    }
}

extension FileManager {
    class func getAppFolderURL() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
