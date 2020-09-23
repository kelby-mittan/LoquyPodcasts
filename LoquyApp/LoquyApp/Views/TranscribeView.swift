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
    
    let audioClip: AudioClip
    
    @State var width : CGFloat = 30
    @State var currentTime: String = "0:00"
    @State var playing = true
    @State var transcription: String = ""
    @State var isTranscribed = false
    
    @State var image = RemoteImage(url: "")
    
    let player = Player.shared.player
    
    private let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            Text(audioClip.title)
                .fontWeight(.heavy)
                .foregroundColor(Color(.label))
                .font(.title)
                .padding(.bottom,6)
            
            NavigationLink(destination: EpisodeDetailView(episode: audioClip.episode, artwork: audioClip.episode.imageUrl ?? "")) {
                
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
                    playing ? player.play() : player.pause()
                }) {
                    Image(systemName: playing ? "pause.fill" : "play.fill").font(.largeTitle)
                        .padding(.trailing)
                }
            }
            .padding([.leading,.trailing,.bottom])
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                
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
                if !isTranscribed {
                    Button(action: {

                        transcribeLiveAudio()
//                        getTranscriptionOfFullFile()
                        
                        isTranscribed = true
                    }) {
                        Text("Transcribe")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 88)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .clipShape(Capsule())
                            .padding()
//                        Spacer()
                    }
                } else {
                    
                    VStack(alignment: .leading) {
                        Text("Your Loquy...")
                            .font(.title)
                            .fontWeight(.heavy)
            
                        MultilineTextField("", text: $transcription, onCommit: {
                            print("Final text: \(transcription)")
                        })
                        
                    }
                    .padding()
                    
                        Button(action: {
                            isTranscribed = false
                            audioEngine.stop()
                            audioEngine.inputNode.removeTap(onBus: 0)
                            print("Your Loquy is : \(transcription)")
                        }) {
                            Text("Save Loquy")
                                .fontWeight(.heavy)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 88)
                                .foregroundColor(.white)
                                .background(Color.purple)
                                .clipShape(Capsule())
                                .padding()
                        }
                    
                }
            }
            Spacer()
        }.onAppear(perform: {
            
            image = RemoteImage(url: audioClip.episode.imageUrl ?? "")
            
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + ".m4a") else {
                print(AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + ".m4a") ?? "Couldn't Find MP3")
                return
                }

            Player.playAudioClip(url: url)
            
            getCurrentPlayerTime()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        Player.getCapsuleWidth(width: &width, currentTime: currentTime)
                    }
                }
            }
        })
        
    }
    
//    private func configAudio() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("error configuring \(error)")
//        }
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            print("ayayayaay")
//        }
//    }
    
    private func transcribeLiveAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("error configuring \(error)")
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Error starting engine: \(error)")
        }
        
        speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            if let theError = error {
                print("recognition error: \(theError)")
            } else {
                transcription = result?.bestTranscription.formattedString ?? "could not get treanscription"
            }
        })
        
    }
    
    private func getTranscriptionOfFullFile() {
        
        player.pause()
        
        playing = true
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + ".m4a") {
                Player.playAudioClip(url: url)

                let request = SFSpeechURLRecognitionRequest(url: url)

                speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                    if let theError = error {
                        print("recognition error: \(theError)")
                    } else {
                        transcription = result?.bestTranscription.formattedString ?? "could not get treanscription"
                    }

                })
                
                

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
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }
    
    func getImageUrl() -> URL? {
        guard let url = URL(string: audioClip.episode.imageUrl ?? "") else {
            return nil
        }
        return url
    }
}

//git rm --cached LoquyApp.xcodeproj/project.xcworkspace/xcuserdata/
