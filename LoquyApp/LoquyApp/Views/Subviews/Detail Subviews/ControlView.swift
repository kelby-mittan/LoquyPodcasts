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
    @State var currentTime: String = "0:00"
    @State var showAlert = false
    
    let player: AVPlayer
    
    @ObservedObject var networkManager: NetworkingManager
        
    @Binding var showModal: Bool
    @Binding var clipTime: String
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.purple).frame(width: width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            handleDraggedCapsule(value)
                        }).onEnded({ (value) in
                            player.seek(to: Player.capsuleDragged(value.location.x))
                            player.play()
                            playing = true
                        }))
                        .padding([.top,.leading,.trailing])
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
                    Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                }) {
                    ZStack {
                        NeoButtonView()
                        Image(systemName: "gobackward.15").font(.largeTitle)
                            .foregroundColor(.purple)
                    }.background(NeoButtonView())
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                    
                }.offset(x: 20)
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                
                Button(action: {
                    playing.toggle()
                    playing ? player.play() : player.pause()
                }) {
                    ZStack {
                        NeoButtonView()
                        Image(systemName: playing ? "pause.fill" : "play.fill").font(.largeTitle)
                            .foregroundColor(.purple)
                    }.background(NeoButtonView())
                    .frame(width: 80, height: 80)
                    .clipShape(Capsule())
                    .animation(.spring())
                }
                
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                
                Button(action: {
                    Player.seekToCurrentTime(delta: 15)
                    Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                }) {
                    ZStack {
                        NeoButtonView()
                        Image(systemName: "goforward.15").font(.largeTitle)
                            .foregroundColor(.purple)
                    }
                    .background(NeoButtonView())
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                }
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                .offset(x: -20)
                
            }
            HStack {
                Spacer()
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
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
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
            playing = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    }
                }
            }
        }
        
    }
    
    private func handleDraggedCapsule(_ dragVal: DragGesture.Value) {
        player.pause()
        let x = dragVal.location.x
        let maxVal = UIScreen.main.bounds.width - 30
        let minVal: CGFloat = 10

        if x < minVal {
            width = minVal
        } else if x > maxVal {
            width = maxVal
        } else {
            width = x
        }
        currentTime = Player.capsuleDragged(dragVal.location.x).toDisplayString()
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
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }


}

