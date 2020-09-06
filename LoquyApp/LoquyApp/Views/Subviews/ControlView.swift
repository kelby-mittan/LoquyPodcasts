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
//import AVFoundation


struct Message: Identifiable {
    let id = UUID()
    let text: String
}

struct ControlView: View {
    
    let episode: Episode
    
    @State var width : CGFloat = 10
    @State var playing = true
    @State var isFirstPlay = false
    @State var currentTime: String = "0:00"
    @State var isRecording = false
    
    @State var showAlert = false
    
//    let showTheAlert: Bool
    
//    @ObservedObject private var networkManager = NetworkingManager()
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            self.player.pause()
                            let x = value.location.x
                            let maxVal = UIScreen.main.bounds.width - 30
                            let minVal: CGFloat = 10
                            
                            if x < minVal {
                                self.width = minVal
                            } else if x > maxVal {
                                self.width = maxVal
                            } else {
                                self.width = x
                            }
                            self.currentTime = self.capsuleDragged(value.location.x).toDisplayString()
                            print("width val is : \(self.width)")
                            
                        }).onEnded({ (value) in
                            self.player.seek(to: self.capsuleDragged(value.location.x))
                            self.player.play()
                            self.playing = true
                        })).padding([.top,.leading,.trailing])
                
            }
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(getCurrentPlayerTime().durationTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding([.leading,.trailing])
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
                
                Button(action: {
                    Player.seekToCurrentTime(delta: -15, player: self.player)
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
                    Player.seekToCurrentTime(delta: 15, player: self.player)
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            HStack {
//                Spacer()
                Button(action: {
                    self.showAlert.toggle()
//                    self.networkManager.updateShowAlert(showAlert: self.showAlert)
//                    print(self.networkManager.isShowAlert)
                }) {
//                    Image(systemName: "timer").font(.largeTitle)
                    Text("Time Stamp")
                        .fontWeight(.medium)
                        .frame(width: 120,height: 40)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                }
                .animation(.spring())
                .buttonStyle(PlainButtonStyle())
                .padding([.leading,.top],20)
                Spacer()
                Button(action: {
                    
    //                guard let streamURL = URL(string: self.episode.streamUrl) else {
    //                    print("COULD NOT GET STREAM URL")
    //                    return
    //                }
    //                let asset = AVAsset(url: streamURL)
    //
    //                AudioTrim.exportAsset(asset: asset, fileName: "PLEASEWORK", stream: self.episode.streamUrl)
//                    Text("Coming Soon")
                    
                }) {
//                    Image(systemName: "recordingtape").font(.largeTitle)
                    Text("Record Clip")
                        .fontWeight(.medium)
                        .frame(width: 120,height: 40)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                }
                .padding([.top,.trailing],20)
                Spacer()
            }
            .padding([.leading,.trailing])
            .blur(radius: showAlert ? 30 : 0)
            if showAlert {
                TimeStampAlertView(showAlert: $showAlert, timeStamp: $currentTime)
                .offset(x: 0, y: -70)
            }
            
        }
        .animation(.spring())
        .onAppear {
            Player.playEpisode(episode: self.episode, player: self.player)
            self.getCurrentPlayerTime()
            
            print(self.episode.fileUrl ?? "error")
        }
        
    }
    
    /// Function determines the AVPlayer's current playing time and its percentage of the full podcast duration
    /// - Returns: CGFloat representing where the Capsule should be on the screen
    private func updateTimeCapsule() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
    /// Function determines where to seek to within a podcast based on a capsule drag
    /// - Parameter xVal: CGFloat determined from a Capsules x location
    /// - Returns: A CMTime to be used when seeking a certain time in a podcast
    @discardableResult
    private func capsuleDragged(_ xVal: CGFloat) -> CMTime {
        //        let x = value.location.x
        let screen = UIScreen.main.bounds.width - 30
        let percentage = xVal / screen
        
        guard let duration = self.player.currentItem?.duration else { return CMTime(value: 0, timescale: 0) }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        return seekTime
    }
    
    
    @discardableResult
    private func getCurrentPlayerTime() -> (currentTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTime = time.toDisplayString()
        }
        let durationTime = self.player.currentItem?.duration
        guard let dt = durationTime else { return ("0:00","0:00") }
        durationLabel = dt.toDisplayString()
        return ("",durationLabel)
    }
    

}

