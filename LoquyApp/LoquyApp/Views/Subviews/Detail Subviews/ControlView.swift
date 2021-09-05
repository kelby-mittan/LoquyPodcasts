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
    @Binding var domColor: UIColor?
    
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
                
                Capsule().fill(Color(domColor ?? .lightGray))
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
                        NeoButtonView(domColor: $domColor)
                        Image(systemName: Symbol.back).font(.largeTitle)
                            .foregroundColor(Color(domColor ?? .lightGray))
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                    
                }
                .offset(x: 20)
                
                Button(action: {
                    handlePlayPausePressed()
                }) {
                    ZStack {
                        NeoButtonView(domColor: $domColor)
                        Image(systemName: playing ? Symbol.pause : Symbol.play)
                            .font(.largeTitle)
                            .foregroundColor(Color(domColor ?? .lightGray))
                        
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Capsule())
                    .animation(.spring())
                }
                
                Button(action: {
                    Player.seekToCurrentTime(delta: 15)
                    Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                }) {
                    ZStack {
                        NeoButtonView(domColor: $domColor)
                        Image(systemName: Symbol.forward).font(.largeTitle)
                            .foregroundColor(Color(domColor ?? .lightGray))
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                }
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
                        .foregroundColor(Color(domColor ?? .lightGray))
                        .background(NeoButtonView(domColor: $domColor))
                        .clipShape(Capsule())
                        .padding()
                }
                .animation(.spring())

                Button(action: {
                    showAlert.toggle()
                }) {
                    Text(RepText.timeStamp)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width - 88,height: 44)
                        .foregroundColor(Color(domColor ?? .lightGray))
                        .background(NeoButtonView(domColor: $domColor))
                        .clipShape(Capsule())
                        .padding([.horizontal,.bottom])
                }
                .animation(.spring())
                .buttonStyle(PlainButtonStyle())
                .offset(y: -10)
            }
            .padding(.horizontal)
            .blur(radius: showAlert ? 30 : 0)
        }
        .sheet(isPresented: $showAlert, content: {
            TimeStampAlertView(showAlert: $showAlert, time: $currentTime, episode: episode)
                .offset(y: 80)
                .background(BackgroundClearView())
                .environmentObject(viewModel)
        })
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

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
