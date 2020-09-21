//
//  TranscribeView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit

struct TranscribeView: View {
    
    let audioClip: AudioClip
    
    @State var width : CGFloat = 30
    @State var currentTime: String = "0:00"
    @State var playing = true
//    @State var paused = true
    @State var transcription: String = ""
    @State var isTranscribed = false
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack {
                RemoteImage(url: audioClip.episode.imageUrl ?? "")
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
            .padding()
            
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
                            currentTime = Player.capsuleDragged(value.location.x,player: player).toDisplayString()
                            print("width val is : \(width)")
                            
                        }).onEnded({ (value) in
                            player.seek(to: Player.capsuleDragged(value.location.x, player: player))
                            player.play()
                            playing = true
                        }))
            }.padding([.leading,.trailing])
//            .padding(.top)
            
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
                        transcription = "Donec ultricies massa dui, dapibus auctor nibh pharetra eu. Cras vestibulum nisl quis sem ullamcorper interdum. Quisque eget varius sem. Nunc vitae massa ac erat interdum fringilla vel quis nulla. Phasellus a pharetra orcidsalvaskvm."
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
        }.onAppear(perform: {
            
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + ".m4a") else {
                print(AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + ".m4a") ?? "Couldn't Find MP3")
                return
                }

            Player.playAudioClip(url: url, player: player)
            
            getCurrentPlayerTime()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if playing {
                    if player.currentItem?.duration.toDisplayString() != "--:--" && width > 0.0 {
                        getCapsuleWidth()
                    }
                }
            }
        })
        .padding(.top, 20)
        
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
        durationLabel = "-" + dt.toDisplayString()
        return ("",durationLabel)
    }
    
//    func getStaticImage() -> View {
//        let image = RemoteImage(url: audioClip.episode.imageUrl ?? "")
//            .frame(width: 100, height: 100)
//            .cornerRadius(6)
//        return image
//    }
}

