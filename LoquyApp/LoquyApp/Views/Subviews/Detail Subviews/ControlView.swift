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
    
    @State var halfModal_shown = false
    
    @Binding var showModal: Bool
    @Binding var clipTime: String
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.blue).frame(width: width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            player.pause()
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
                            currentTime = Player.capsuleDragged(value.location.x,player: player).toDisplayString()
                            print("width val is : \(width)")
                            
                        }).onEnded({ (value) in
                            player.seek(to: Player.capsuleDragged(value.location.x, player: player))
                            player.play()
                            playing = true
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
                    
                    
                    
                    Player.seekToCurrentTime(delta: -15, player: player)
                    
//                    guard let url = AudioTrim.loadUrlFromDiskWith(fileName: self.episode.title + ".m4a") else {
//                        print(AudioTrim.loadUrlFromDiskWith(fileName: self.episode.title + ".m4a") ?? "Couldn't Find MP3")
//                        return
//                        }
//
//
//                    Player.playAudioClip(url: url, player: self.player)
                    
//                    dump(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
                }) {
                    Image(systemName: "gobackward.15").font(.largeTitle)
                }
                
                Button(action: {
                    playing.toggle()
                    playing ? player.play() : player.pause()
                    
                }) {
                    Image(systemName: playing ? "pause.fill" : "play.fill").font(.largeTitle)
                }
                
                Button(action: {
                    Player.seekToCurrentTime(delta: 15, player: player)
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            HStack {
                Button(action: {
                    showAlert.toggle()
                }) {
                    Text("time stamp")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .frame(width: 122,height: 44)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                }
                .animation(.spring())
                .buttonStyle(PlainButtonStyle())
                .padding([.leading],20)
                Spacer()
                
//                NavigationLink(destination: Text("Coming Soon!")) {
//                    Text("Record Clip")
//                    .fontWeight(.medium)
//                    .frame(width: 120,height: 40)
//                    .foregroundColor(.white)
//                    .background(Color.purple)
//                    .clipShape(Capsule())
//                    .padding()
//                }.padding([.top,.trailing],20)
                
                Button(action: {

                    showModal.toggle()
                    clipTime = currentTime
//                    AudioTrim.exportUsingComposition(streamUrl: self.episode.streamUrl, pathForFile:  self.episode.title)
                    
//                    dump(UserDefaults.standard.savedTimeStamps().filter { $0.episode == self.episode }.map { $0.time })

                }) {
                    Text("record clip")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .frame(width: 122,height: 44)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                    }
                .animation(.spring())
                .padding([.trailing],20)
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
            Player.playEpisode(episode: episode, player: player)
            getCurrentPlayerTime()
                        
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in

                if playing {

                    let screen = UIScreen.main.bounds.width - 30
                    
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        print("here")
                        print(currentTime)
                        let duration = player.currentItem?.duration.toDisplayString() ?? "00:00:00"
                        print(player.currentItem?.duration.toDisplayString() ?? "00:00:00")
                        let percent = currentTime.toSecDouble() / duration.toSecDouble()
                        width = screen * CGFloat(percent)
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
        guard let durationTime = player.currentItem?.duration else {
            return ("--:--", "--:--")
        }
        let dt = durationTime - currentTime.getCMTime()
//        guard let dt = durationTime else { return ("00:00:00","00:00:00") }
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }


}

