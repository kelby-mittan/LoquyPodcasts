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

struct TranscribeView: View {
    
    @ObservedObject var networkManager = NetworkingManager()
    
    let audioClip: AudioClip
    
    @State var width : CGFloat = 30
    @State var currentTime: String = "0:00"
    @State var playing = false
    @State var transcription: String = ""
    @State var title: String = ""
    @State var isTranscribing = false
    @State var saveText = "transcribe"
    @State var image = RemoteImage(url: "")
    @State var showNotification = false
    @State var notificationMessage = ""
    @State var showAlert = false
    
    let player = Player.shared.player
    var speechRecognizer = SFSpeechRecognizer()
    @State var startedPlaying = 0
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                Text(audioClip.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.label))
                    .font(.title)
                    .padding(.bottom,6)
                
                NavigationLink(destination: EpisodeDetailView(episode: audioClip.episode, artwork: audioClip.episode.imageUrl ?? "", feedUrl: audioClip.feedUrl)) {
                    
                    Text(audioClip.episode.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.purple)
                        .font(.headline)
                        .padding([.leading,.trailing])
                }.onTapGesture(perform: {
                    playing = false
                })
                
                Text(audioClip.startTime + " - " + audioClip.endTime)
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
                        playing.toggle()
                        handlePlay()
                        playing ? player.play() : player.pause()
                    }) {
                        ZStack {
                            NeoButtonView()
                            Image(systemName: playing ? "pause.fill" : "play.fill").font(.largeTitle)
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
                    Capsule().fill(Color.purple).frame(width: width, height: 8)
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
                    Text(getCurrentPlayerTime().durationTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
                
                Group {
                    if isTranscribing {
                        VStack(alignment: .leading) {
                            Text("Your Loquy...")
                                .font(.title)
                                .fontWeight(.heavy)
                            MultilineTextField("", isSaved: false, text: $transcription, onCommit: {
                                player.pause()
                                DispatchQueue.main.async {
                                    playing = false
                                }
                            })
                        }.padding()
                    }
                }
                Button(action: {
                    isTranscribing.toggle()
                    if isTranscribing {
                        getTranscriptionOfClippedFile()
                        saveText = "save loquy"
                        
                    } else {
                        saveText = "transcribe"
                        player.pause()
                        playing = false
                        showAlert.toggle()
                    }
                    
                }) {
                    Text(saveText)
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
                    SaveLoquyAlertView(showAlert: $showAlert, notificationShown: $showNotification, message: $notificationMessage, networkManager: networkManager, audioClip: audioClip, transcription: transcription, isPlaying: player.timeControlStatus == .playing)
                    .offset(x: 0, y: -70)
                }
            }.onAppear {
                image = RemoteImage(url: audioClip.episode.imageUrl ?? "")
                getLoquyTranscriptions()
        }
            NotificationView(message: $notificationMessage)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0))
        }
    }
    
    private func handlePlay() {
        startedPlaying += 1
        if startedPlaying == 1 {
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + ".m4a") else {
                return
            }

            Player.playAudioClip(url: url)
            playing = true
            getCurrentPlayerTime()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    }
                }
            }
        }
        
    }
    
    private func getTranscriptionOfClippedFile() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + ".m4a") {
                
                AudioTrim.trimUsingComposition(url: url, start: currentTime, duration: audioClip.duration, pathForFile: "trimmedFile") { (result) in
                    switch result {
                    case .success(let clipUrl):
                        let request = SFSpeechURLRecognitionRequest(url: clipUrl)
                        speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                            if let theError = error {
                                print("recognition error: \(theError)")
                            } else {
                                if playing {
                                    transcription = result?.bestTranscription.formattedString ?? "could not get transcription"
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
    
    @discardableResult
    private func getCurrentPlayerTime() -> (currentTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            if startedPlaying > 0 {
                currentTime = time.toDisplayString()
            }
        }
        guard let durationTime = player.currentItem?.duration else {
            return ("--:--", "--:--")
        }
        let dt = durationTime - currentTime.getCMTime()
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }
    
    func getLoquyTranscriptions() {
        networkManager.loadLoquys()
    }
}
