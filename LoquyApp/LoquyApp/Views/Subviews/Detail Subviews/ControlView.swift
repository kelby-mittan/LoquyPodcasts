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

struct ControlView: View {
    
    let episode: Episode
    
    @State var width: CGFloat = 30
    @State var playing = true
    @State var isFirstPlay = false
    @State var currentTime: String = "0:00"
    @State var isRecording = false
    
    @State var showAlert = false
    
    let player: AVPlayer
    
    @ObservedObject var networkManager: NetworkingManager
    
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
                            self.currentTime = Player.capsuleDragged(value.location.x,player: self.player).toDisplayString()
                            print("width val is : \(self.width)")
                            
                        }).onEnded({ (value) in
                            self.player.seek(to: Player.capsuleDragged(value.location.x, player: self.player))
                            self.player.play()
                            self.playing = true
                        })).padding([.top,.leading,.trailing])
            }
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(self.getCurrentPlayerTime().durationTime)
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
                Button(action: {
                    self.showAlert.toggle()
                }) {
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
//                    dump(UserDefaults.standard.savedTimeStamps().filter { $0.episode == self.episode }.map { $0.time })
                    
                }) {
                    Text("Record Clip")
                        .fontWeight(.medium)
                        .frame(width: 120,height: 40)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                }
                .animation(.spring())
                .padding([.top,.trailing],20)
                Spacer()
            }
            .padding([.leading,.trailing])
            .blur(radius: showAlert ? 30 : 0)
            if showAlert {
                TimeStampAlertView(showAlert: $showAlert, time: $currentTime, episode: episode, networkManager: networkManager)
                .offset(x: 0, y: -70)
            }
            
        }
        .animation(.spring())
        .onAppear {
            Player.playEpisode(episode: self.episode, player: self.player)
            self.getCurrentPlayerTime()
            
            print(self.episode.fileUrl ?? "error")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in

                if self.playing {

                    let screen = UIScreen.main.bounds.width - 30
                    
                    if self.player.currentItem?.duration.toDisplayString() != "--:--" && self.width > 0.0 {
                        print("here")
                        print(self.currentTime)
                        let duration = self.player.currentItem?.duration.toDisplayString() ?? "00:00:00"
                        print(self.player.currentItem?.duration.toDisplayString() ?? "00:00:00")
                        let percent = self.currentTime.toSecDouble() / duration.toSecDouble()
                        self.width = screen * CGFloat(percent)
                    }
                }
            }
        }
        
    }
    
    @discardableResult
    private func getCurrentPlayerTime() -> (currentTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTime = time.toDisplayString()
        }
        let durationTime = self.player.currentItem?.duration
        guard let dt = durationTime else { return ("00:00:00","00:00:00") }
        durationLabel = dt.toDisplayString()
        return ("",durationLabel)
    }


}

