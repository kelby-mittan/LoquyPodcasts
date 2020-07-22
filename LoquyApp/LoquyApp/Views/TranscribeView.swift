//
//  TranscribeView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct TranscribeView: View {
    
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    
    @State var width : CGFloat = 30
    @State var playing = false
    @State var paused = true
    @State var transcription: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            
            HStack {
                PodcastPosterView(podcast: DummyPodcast.podcasts[4], width: 100, height: 100)
                //                    .padding(.leading)
                Spacer()
                
                Button(action: {
                    self.paused.toggle()
                    self.playing.toggle()
                }) {
                    Image(systemName: self.playing && !self.paused ? "pause.fill" : "play.fill").font(.largeTitle)
                        .padding(.trailing)
                }
            }
            .padding()
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                            let x = value.location.x
                            
                            self.width = x
                            
                        }).onEnded({ (value) in
                            
                        }))
            }
            .padding(.top)
            
            HStack {
                Text("0:00")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                Spacer()
                Text("2:30")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 4)
            }
            
            Button(action: {
                self.transcription = "Donec ultricies massa dui, dapibus auctor nibh pharetra eu. Cras vestibulum nisl quis sem ullamcorper interdum. Quisque eget varius sem. Nunc vitae massa ac erat interdum fringilla vel quis nulla. Phasellus a pharetra orcidsalvaskvm."
                
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
            
            MultilineTextField("", text: $transcription, onCommit: {
                print("Final text: \(self.transcription)")
            })
            
            Button(action: {
                
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
        .padding(.top, 20)
        
    }
}

struct TranscribeView_Previews: PreviewProvider {
    static var previews: some View {
        TranscribeView(podcast: DummyPodcast.podcasts[4])
    }
}
