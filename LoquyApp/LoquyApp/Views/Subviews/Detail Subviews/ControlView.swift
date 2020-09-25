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
                            currentTime = Player.capsuleDragged(value.location.x).toDisplayString()
                            print("width val is : \(width)")
                            
                        }).onEnded({ (value) in
                            player.seek(to: Player.capsuleDragged(value.location.x))
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
                    
                    Player.seekToCurrentTime(delta: -15)
                    getCapsuleWidth()
                    
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
                    Player.seekToCurrentTime(delta: 15)
                    getCapsuleWidth()
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            HStack {
                Button(action: {
                    showAlert.toggle()
                }) {
                    Text("time stamp")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(width: 122,height: 44)
                        .foregroundColor(.purple)
                        .background(NeoButtonView())
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 10, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                .animation(.spring())
                .buttonStyle(PlainButtonStyle())
                .padding([.leading],20)
                Spacer()
                
                Button(action: {

                    showModal.toggle()
                    clipTime = currentTime

                }) {
                    Text("record clip")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(width: 122,height: 44)
                        .foregroundColor(.purple)
                        .background(NeoButtonView())
                        .clipShape(Capsule())
                        .padding()
                    }
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 10, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
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
            Player.playEpisode(episode: episode)
            getCurrentPlayerTime()
                        
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        getCapsuleWidth()
                    }
                }
            }
        }
        
    }
    
    private func getCapsuleWidth() {
        let screen = UIScreen.main.bounds.width - 30
        let duration = player.currentItem?.duration.toDisplayString() ?? "00:00:00"
        let percent = currentTime.toSecDouble() / duration.toSecDouble()
        width = screen * CGFloat(percent) + 20
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

