//
//  TranscribeView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit
import Speech

@available(iOS 14.0, *)
struct TranscribeView: View {
    
    let audioClip: AudioClip
    
    @ObservedObject var viewModel = ViewModel.shared
    @ObservedObject var scribeViewModel = TranscriptionViewModel.shared
    
    @State var image = RemoteImageDetail(url: RepText.empty)
    @State var showNotification = false
    @State var notificationMessage = RepText.empty
    
    let player = Player.shared.player
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                Text(audioClip.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.label))
                    .font(.title)
                    .padding(.bottom,6)
                
                NavigationLink(destination: EpisodeDetailView(episode: audioClip.episode, artwork: audioClip.episode.imageUrl ?? RepText.empty, feedUrl: audioClip.feedUrl, isDeepLink: false)) {
                    
                    Text(audioClip.episode.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.purple)
                        .font(.headline)
                        .padding([.leading,.trailing])
                }.onTapGesture(perform: {
                    scribeViewModel.playing = false
                })
                
                Text(audioClip.startTime + TimeText.dash + audioClip.endTime)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.label))
                    .font(.subheadline)
                    .padding(.top,4)
                
                HStack {
                    image
                        .frame(width: 100, height: 100)
                        .cornerRadius(6)
                    Spacer()
                    Button(action: {
                        scribeViewModel.playing.toggle()
                        
                        scribeViewModel.handlePlay(audioClip)
                        
                        scribeViewModel.playing ? player.play() : player.pause()
                    }) {
                        ZStack {
                            NeoButtonView()
                            Image(systemName: scribeViewModel.playing ? Symbol.pause : Symbol.play).font(.largeTitle)
                                .foregroundColor(.purple)
                                
                        }
                        .background(NeoButtonView())
                        .frame(width: 64, height: 64)
                        .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                        .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                        .clipShape(Capsule())
                        .padding(.trailing)
                    }
                }
                .padding([.leading,.trailing,.bottom])
                
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    Capsule().fill(Color.purple).frame(width: scribeViewModel.width, height: 8)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                player.pause()
                                Player.handleWidth(value, &scribeViewModel.width, &scribeViewModel.currentTime)
                                
                            }).onEnded({ (value) in
                                player.seek(to: Player.capsuleDragged(value.location.x))
                                player.play()
                                scribeViewModel.playing = true
                            }))
                }.padding([.leading,.trailing])
                
                HStack {
                    Text(scribeViewModel.currentTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    Spacer()
                    Text(scribeViewModel.timeToDisplay())
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
                
                Group {
                    if scribeViewModel.isTranscribing {
                        VStack(alignment: .leading) {
                            Text(RepText.yourLoquy)
                                .font(.title)
                                .fontWeight(.heavy)
                            MultilineTextField(RepText.empty, isSaved: false, text: $scribeViewModel.transcription, onCommit: {
                                player.pause()
                                DispatchQueue.main.async {
                                    scribeViewModel.playing = false
                                }
                            })
                        }.padding()
                    }
                }
                Button(action: {
                    scribeViewModel.handleIsTranscribing(audioClip)
                    
                }) {
                    Text(scribeViewModel.isTranscribing
                            ? RepText.saveLoquy
                            : RepText.transcribe)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 88)
                        .foregroundColor(.purple)
                        .background(NeoButtonView())
                        .clipShape(Capsule())
                        .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 16, x: 10, y: 10)
                        .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
                        .padding()
                }
                Spacer()
                if scribeViewModel.showAlert {
                    SaveLoquyAlertView(showAlert: $scribeViewModel.showAlert, notificationShown: $showNotification, message: $notificationMessage, audioClip: audioClip, transcription: scribeViewModel.transcription, isPlaying: scribeViewModel.playing)
                    .offset(x: 0, y: -70)
                }
            }.onAppear {
                image = RemoteImageDetail(url: audioClip.episode.imageUrl ?? RepText.empty)
                viewModel.loadLoquys()
        }
            NotificationView(message: $notificationMessage)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0))
        }
    }
    
}
