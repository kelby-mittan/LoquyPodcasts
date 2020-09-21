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
    
    @State var showActionSheet: Bool = false
    @State var audioClip = UserDefaults.standard.savedAudioClips().first
    
    
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
                                    .onLongPressGesture {
                                        audioClip = clip
                                        showActionSheet.toggle()
                                    }
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
            .actionSheet(isPresented: $showActionSheet, content: {
                actionSheet
            })
            
            //            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Your Audio Clips")
            
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Remove Clip").font(.title), buttons: [
            .default(Text("Cancel")) {
                dump(UserDefaults.standard.savedAudioClips().filter { $0.startTime != audioClip?.startTime } )
            },
            .destructive(Text("Delete")) {
                print("clicked DELETE")
                
                guard let audioClip = UserDefaults.standard.savedAudioClips().filter({ $0.episode.description == audioClip?.episode.description && $0.startTime == audioClip?.startTime }).first else {
                    return
                }
                
                dump(audioClip)
                UserDefaults.standard.deleteAudioClip(clip: audioClip)
                getAudioClips()
            }
            
        ])
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
