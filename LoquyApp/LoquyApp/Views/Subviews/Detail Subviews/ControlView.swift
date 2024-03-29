//
//  ControlView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 8/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct ControlView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    // MARK: injected properties
    
    let episode: Episode
    @Binding var isPlaying: Bool
    @Binding var showModal: Bool
    @Binding var clipTime: String
    @Binding var dominantColor: UIColor?
    @Binding var currentTime: String
    @Binding var showAlert: Bool
    @Binding var timestampTime: String
    var audioClip: AudioClip?
    
    @State var width: CGFloat = 20
    @State var playing = true
            
    let player = Player.shared.player
            
    var body: some View {
        
        VStack {
            durationCapsules
            durationTimes
            controlButtons
            clipAndTimestampButtons
        }
        .onAppear {
            
            
            
            handlePlayOnAppear()
            setupRemoteControl()
            
            
        }
        .onDisappear {
            
            
            
        }
    }
    
    // MARK: computed views
    
    @ViewBuilder var durationCapsules: some View {
        ZStack(alignment: .leading) {
            
            Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                .padding([.top,.horizontal])
            
            Capsule().fill(Color(dominantColor ?? .lightGray))
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
    }
    
    @ViewBuilder var durationTimes: some View {
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
    }
    
    @ViewBuilder var controlButtons: some View {
        HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
            
            Button(action: {
                Player.seekToCurrentTime(delta: -15)
                Player.getCapsuleWidth(width: &width, currentTime: currentTime)
            }) {
                ZStack {
                    NeoButtonView(dominantColor: $dominantColor)
                    Image(systemName: Symbol.back).font(.largeTitle)
                        .foregroundColor(Color(dominantColor ?? .lightGray))
                }
                .frame(width: 60, height: 60)
                .clipShape(Capsule())
                
            }
            .offset(x: 20)
            
            Button(action: {
                handlePlayPausePressed()
            }) {
                ZStack {
                    NeoButtonView(dominantColor: $dominantColor)
                    Image(systemName: playing ? Symbol.pause : Symbol.play)
                        .font(.largeTitle)
                        .foregroundColor(Color(dominantColor ?? .lightGray))
                    
                }
                .frame(width: 80, height: 80)
                .clipShape(Capsule())
                .animation(.spring(), value: playing)
            }
            
            Button(action: {
                Player.seekToCurrentTime(delta: 15)
                Player.getCapsuleWidth(width: &width, currentTime: currentTime)
            }) {
                ZStack {
                    NeoButtonView(dominantColor: $dominantColor)
                    Image(systemName: Symbol.forward).font(.largeTitle)
                        .foregroundColor(Color(dominantColor ?? .lightGray))
                }
                .frame(width: 60, height: 60)
                .clipShape(Capsule())
            }
            .offset(x: -20)
            
        }
    }
    
    @ViewBuilder var clipAndTimestampButtons: some View {
        VStack {
            Button(action: {
                withAnimation(.spring()) {
                    showModal.toggle()
                }
                clipTime = currentTime
            }) {
                Text(RepText.recordClip)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: UIScreen.main.bounds.width - 88, height: 44)
                    .foregroundColor(Color(dominantColor ?? .lightGray))
                    .background(NeoButtonView(dominantColor: $dominantColor))
                    .clipShape(Capsule())
                    .padding()
            }

            Button(action: {
                withAnimation {
                    showAlert.toggle()
                }
                timestampTime = currentTime
            }) {
                Text(RepText.timeStamp)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: UIScreen.main.bounds.width - 88,height: 44)
                    .foregroundColor(Color(dominantColor ?? .lightGray))
                    .background(NeoButtonView(dominantColor: $dominantColor))
                    .clipShape(Capsule())
                    .padding([.horizontal,.bottom])
            }
            .buttonStyle(PlainButtonStyle())
            .offset(y: -10)
        }
        .padding(.horizontal)
        .blur(radius: showAlert ? 30 : 0)
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
            if let clip = audioClip {
                player.seek(to: clip.startTime.getCMTime())
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
