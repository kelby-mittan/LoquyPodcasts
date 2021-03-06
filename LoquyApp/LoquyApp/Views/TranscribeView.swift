//
//  TranscribeView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Speech

@available(iOS 14.0, *)
struct TranscribeView: View {
    
    let audioClip: AudioClip
    
    @ObservedObject var viewModel = ViewModel.shared
//    @ObservedObject var scribeViewModel = TranscriptionViewModel.shared
    
    @State var remoteImage = RemoteImageDetail(url: RepText.empty)
    @State var showNotification = false
    @State var notificationMessage = RepText.empty
    
//
//    @State var playedWidth = TranscriptionViewModel.shared.width
//    @State var currentTime = TranscriptionViewModel.shared.currentTime
//    @State var playing = TranscriptionViewModel.shared.playing
//    @State var transcription = TranscriptionViewModel.shared.transcription
//    @State var isTranscribing = TranscriptionViewModel.shared.isTranscribing
//    @State var showAlert = TranscriptionViewModel.shared.showAlert
//    var speechRecognizer = TranscriptionViewModel.shared.speechRecognizer
//    @State var startedPlaying = TranscriptionViewModel.shared.startedPlaying
    
    @State var playedWidth : CGFloat = 30
    @State var currentTime: String = TimeText.zero
    @State var playing = false
    @State var transcription: String = RepText.empty
    @State var title: String = RepText.empty
    @State var isTranscribing = false
    
    @State var showAlert = false
    
    var speechRecognizer = SFSpeechRecognizer()
    @State var startedPlaying = 0
    
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
                    playing = false
                })
                
                Text(audioClip.startTime + TimeText.dash + audioClip.endTime)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.label))
                    .font(.subheadline)
                    .padding(.top,4)
                
                HStack {
                    remoteImage
                        .frame(width: 100, height: 100)
                        .cornerRadius(6)
                    Spacer()
                    Button(action: {
                        playing.toggle()
                        handlePlay()
                        playing ? player.play() : player.pause()
                    }) {
                        ZStack {
                            NeoButtonView()
                            Image(systemName: playing ? Symbol.pause : Symbol.play).font(.largeTitle)
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
                    Capsule().fill(Color.purple).frame(width: playedWidth, height: 8)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                player.pause()
                                Player.handleWidth(value, &playedWidth, &currentTime)
                            }).onEnded({ (value) in
                                player.seek(to: Player.capsuleDragged(value.location.x))
                                player.play()
                                playing = true
                            }))
                }.padding([.leading,.trailing])
                
                HStack {
                    Text(currentTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    Spacer()
                    Text(timeToDisplay())
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
                
                Group {
                    if isTranscribing {
                        VStack(alignment: .leading) {
                            Text(RepText.yourLoquy)
                                .font(.title)
                                .fontWeight(.heavy)
                            MultilineTextField(RepText.empty, isSaved: false, text: $transcription, onCommit: {
                                player.pause()
                                DispatchQueue.main.async {
                                    playing = false
                                }
                            })
                        }.padding()
                    }
                }
                Button(action: {
                    handleIsTranscribing()
                }) {
                    Text(isTranscribing
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
                if showAlert {
                    SaveLoquyAlertView(showAlert: $showAlert, notificationShown: $showNotification, message: $notificationMessage, audioClip: audioClip, transcription: transcription, isPlaying: player.timeControlStatus == .playing)
                    .offset(x: 0, y: -70)
                }
            }.onAppear {
                remoteImage = RemoteImageDetail(url: audioClip.episode.imageUrl ?? RepText.empty)
                viewModel.loadLoquys()
        }
            NotificationView(message: $notificationMessage)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0))
        }
    }
    
}

extension TranscribeView {
    private func handlePlay() {
        startedPlaying += 1
        if startedPlaying == 1 {
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) else {
                return
            }

            Player.playAudioClip(url: url)
            playing = true

            Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { time in
                currentTime = time
            }

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != TimeText.unloaded && playedWidth > 0.0 {
                        Player.getCapsuleWidth(width: &playedWidth, currentTime: currentTime)
                    }
                }
            }
        }

    }

    private func timeToDisplay() -> String {
        return Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { time in
            currentTime = time
        }
    }

    private func handleIsTranscribing() {
        isTranscribing.toggle()
        if isTranscribing {
            handlePlay()
            getTranscriptionOfClippedFile()
        } else {
            player.pause()
            playing = false
            showAlert.toggle()
        }
    }

    private func getTranscriptionOfClippedFile() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) {

                AudioTrim.trimUsingComposition(url: url, start: currentTime, duration: audioClip.duration, pathForFile: TrimText.trimmedFile) { (result) in
                    switch result {
                    case .success(let clipUrl):
                        let request = SFSpeechURLRecognitionRequest(url: clipUrl)
                        speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                            if let error = error {
                                print(ErrorText.recError+error.localizedDescription)
                            } else {
                                if playing {
                                    transcription = result?.bestTranscription.formattedString ?? RepText.noTranscription
                                }
                            }
                        })
                    default:
                        break
                    }
                }
            }
        }
    }
}
