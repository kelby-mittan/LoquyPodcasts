//
//  AudioClipsView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct AudioClipsView: View {
    
    @ObservedObject private var networkManager = NetworkingManager()
    
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    var body: some View {
        
        NavigationView {
            VStack {
                List(networkManager.audioClips, id: \.self) { clip in
                    
                    NavigationLink(destination: TranscribeView(audioClip: clip)) {
                        
                        ZStack(alignment: .leading) {
                            LinearGradient(gradient: Gradient(colors: [gradColor1!, gradColor2!]), startPoint: .top, endPoint: .bottomTrailing)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 6)
                                .padding(.trailing)
                            
                            VStack(alignment: .center) {
                                
                                Text(clip.savedDate)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
//                                    .padding()
                                    
                                RemoteImage(url: clip.episode.imageUrl ?? "")
                                    .frame(width: 140, height: 140)
                                    .cornerRadius(6)
//                                    .padding([.leading,.bottom,.top])
                                    
                                    Text(clip.title)
                                        .font(.headline)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.semibold)
//                                        .padding([.horizontal])
                                    
                                    Text(clip.episode.title)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.semibold)
//                                        .padding([.horizontal])
                                    
                                
                            }.padding()
                        }
                        
                    }
                    .padding(.trailing, -30).buttonStyle(PlainButtonStyle())
                    
                }
            }.onAppear(perform: {
//                UITableView.appearance().separatorStyle = .none
                getAudioClips()
            })
//            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Your Audio Clips")
            
        }
    }
    
    func getAudioClips() {
        networkManager.loadAudioClips()
    }
}

struct AudioClipsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioClipsView()
    }
}
