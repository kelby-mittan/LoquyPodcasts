//
//  ControlView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 8/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import MediaPlayer

@available(iOS 14.0, *)
struct ControlView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    let episode: Episode
    @Binding var isPlaying: Bool
    @Binding var showModal: Bool
    @Binding var clipTime: String
    
    @State var width: CGFloat = 20
    @State var playing = true
    @State var currentTime: String = TimeText.zero
    @State var showAlert = false
    
    let player = Player.shared.player
            
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.horizontal])
                
                Capsule().fill(Color.purple)
                    .frame(width: width.isFinite ? width : 30, height: 8)
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    player.pause()
                                    Player.handleWidth(value, &width, &currentTime)
                                }).onEnded({ (value) in
                                            player.seek(to: Player.capsuleDragged(value.location.x))
                                            player.play()
                                            playing = true
                                            isPlaying = true
                                }))
                    .padding([.top,.horizontal])
                    .onChange(of: currentTime, perform: { value in
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    })
            }
            .padding([.leading,.trailing],8)
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading,8)
                Spacer()
                Text(handleTimeDisplayed())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing,8)
            }
            .padding(.horizontal)
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
                
                Button(action: {
                    Player.seekToCurrentTime(delta: -15)
                    Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                }) {
                    ZStack {
                        NeoButtonView()
                        Image(systemName: Symbol.back).font(.largeTitle)
                            .foregroundColor(.purple)
                    }.background(NeoButtonView())
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                    
                }
                .offset(x: 20)
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                
                Button(action: {
                    handlePlayPausePressed()
                }) {
                    ZStack {
                        NeoButtonView()
                        Image(systemName: playing ? Symbol.pause : Symbol.play)
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        
                    }
                    .background(NeoButtonView())
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
                        Image(systemName: Symbol.forward).font(.largeTitle)
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
            VStack {
                Button(action: {
                    showModal.toggle()
                    clipTime = currentTime
                }) {
                    Text(RepText.recordClip)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width - 88, height: 44)
                        .foregroundColor(.purple)
                        .background(NeoButtonView())
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 10, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                .animation(.spring())

                Button(action: {
                    showAlert.toggle()
                }) {
                    Text(RepText.timeStamp)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width - 88,height: 44)
                        .foregroundColor(.purple)
                        .background(NeoButtonView())
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                .animation(.spring())
                .buttonStyle(PlainButtonStyle())
                .offset(y: -10)
            }
            .padding(.horizontal)
            .blur(radius: showAlert ? 30 : 0)
            if showAlert {
                TimeStampAlertView(showAlert: $showAlert, time: $currentTime, episode: episode)
                    .offset(x: 0, y: -70)
                    .environmentObject(viewModel)
            }
            
        }
        .animation(.spring())
        .onAppear {
            handlePlayOnAppear()
            setupRemoteControl()
        }
    }
}

extension ControlView {
    
    private func handlePlayOnAppear() {
        viewModel.handleIsPlaying()
        isPlaying = viewModel.playing
        
        if !viewModel.playing {
            viewModel.episodePlaying = episode.title
            Player.playEpisode(episode: episode)
            if let deepLinkTime = episode.deepLinkTime {
                player.seek(to: deepLinkTime.getCMTime())
            }
            playing = true
            isPlaying = true
            
        } else {
            Player.getCapsuleWidth(width: &width, currentTime: currentTime)
            if viewModel.episodePlaying != episode.title {
                playing = false
            }
        }
        
        Player.getCurrentPlayerTime(currentTime, episode.title == viewModel.episodePlaying) { time in
            currentTime = time
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
            if viewModel.playing {
                if player.currentItem?.duration.toDisplayString() != TimeText.unloaded && width > 0.0 {
                    Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    
                }
            }
        }
    }
    
    private func handlePlayPausePressed() {
        if episode.title == viewModel.episodePlaying {
            !playing ? player.play() : player.pause()
            playing.toggle()
            isPlaying.toggle()
        } else {
            viewModel.episodePlaying = episode.title
            Player.playEpisode(episode: episode)
            playing = true
        }
    }
    
    private func handleTimeDisplayed() -> String {
        return Player.getCurrentPlayerTime(currentTime, episode.title == viewModel.episodePlaying) { ctime in
            currentTime = ctime
        }
    }
    
    private func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()

        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            player.play()
            playing = true
            isPlaying = true
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            player.pause()
            playing = false
            isPlaying = false
            return .success
        }

        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in

            if player.timeControlStatus == .playing {
                player.pause()
            } else {
                player.play()
            }

            return .success
        }

    }
}
