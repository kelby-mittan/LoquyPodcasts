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

@available(iOS 14.0, *)
struct ControlView: View {
    
    let episode: Episode
    
    @State var width: CGFloat = 20
    @State var playing = true
    @State var currentTime: String = "0:00"
    @State var showAlert = false
    
    @Binding var isPlaying: Bool
    
    let player: AVPlayer
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var showModal: Bool
    @Binding var clipTime: String
        
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.purple)
                    .frame(width: width.isFinite ? width : 30, height: 8)
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    player.pause()
//                                    playing = false
                                    Player.handleWidth(value, &width, &currentTime)
//                                    handleDraggedCapsule(value)
                                }).onEnded({ (value) in
                                    player.seek(to: Player.capsuleDragged(value.location.x))
                                    player.play()
                                    playing = true
//                                    !playing ? player.play() : player.pause()
//                                    viewModel.playing ? player.play() : player.pause()
                                }))
                    .padding([.top,.leading,.trailing])
                    .onChange(of: currentTime, perform: { value in
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    })
            }
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(handleTimeDisplayed())
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
                    if episode.title != viewModel.episodePlaying {
                        viewModel.episodePlaying = episode.title
                        Player.playEpisode(episode: episode)
                    }
                    
                    !playing ? player.play() : player.pause()
                    
                    playing.toggle()
                    isPlaying.toggle()
//                    viewModel.playing ? player.pause() : player.play()
                                        
//                    viewModel.handleIsPlaying()
                    
                    
                    
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
//                    getCurrentPlayerTime()
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
                TimeStampAlertView(showAlert: $showAlert, time: $currentTime, episode: episode, networkManager: viewModel)
                    .offset(x: 0, y: -70)
            }
            
        }
        .animation(.spring())
        .onAppear {
            
            viewModel.handleIsPlaying()
            isPlaying = viewModel.playing
            
            if let deepLinkTime = episode.deepLinkTime {
                player.seek(to: deepLinkTime.getCMTime())
            }
            
            if !viewModel.playing {
                viewModel.episodePlaying = episode.title
                Player.playEpisode(episode: episode)
                
                playing = true
                isPlaying = true
                
            } else {
                Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                if viewModel.episodePlaying != episode.title {
                    playing = true
                }
                
            }
//            getCurrentPlayerTime()
            
            Player.getCurrentPlayerTime(currentTime, episode.title == viewModel.episodePlaying) { time in
                currentTime = time
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if viewModel.playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                        
                    }
                }
            }
            Player.setupRemoteControl()
        }
                
    }
    
    private func handleTimeDisplayed() -> String {
        return Player.getCurrentPlayerTime(currentTime, episode.title == viewModel.episodePlaying) { ctime in
            currentTime = ctime
        }
    }
    
    
//    private func setupRemoteControl() {
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//
//        let commandCenter = MPRemoteCommandCenter.shared()
//
//        commandCenter.playCommand.isEnabled = true
//        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
//            player.play()
//            playing = true
//            isPlaying = true
//            return .success
//        }
//
//        commandCenter.pauseCommand.isEnabled = true
//        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
//            player.pause()
//            playing = false
//            isPlaying = false
//            return .success
//        }
//
//        commandCenter.togglePlayPauseCommand.isEnabled = true
//        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
//
//            if player.timeControlStatus == .playing {
//                player.pause()
//            } else {
//                player.play()
//            }
//
//            return .success
//        }
//
//    }
    
}

