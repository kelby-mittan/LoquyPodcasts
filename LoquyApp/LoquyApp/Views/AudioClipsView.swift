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
    @State var audioClip: AudioClip?
    
    var body: some View {
        
        if !networkManager.audioClips.isEmpty {
            NavigationView {
                List(networkManager.audioClips, id: \.self) { clip in
                    
                    NavigationLink(destination: TranscribeView(audioClip: clip)) {
                        
                        ZStack(alignment: .center) {
                            ZStack {
                                Color(#colorLiteral(red: 0.9889873862, green: 0.9497770667, blue: 1, alpha: 1))
                                    .offset(x: -10, y: -10)
                                LinearGradient(gradient: Gradient(colors: [gradColor1!, gradColor2!]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .padding(2)
                                    .blur(radius: 4)
                            }
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 6)
                            .padding(.trailing)
                            
                            VStack(alignment: .center) {
                                
                                Text(clip.savedDate)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
                                
                                
                                RemoteImage(url: clip.episode.imageUrl ?? "")
                                    .frame(width: 140, height: 140)
                                    .cornerRadius(6)
                                    .onLongPressGesture {
                                        audioClip = clip
                                        showActionSheet.toggle()
                                    }
                                
                                Text(clip.title)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                                    .onTapGesture(perform: {
                                        dump(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].pathComponents)
                                    })
                                
                                Text(clip.episode.title)
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                                
                                
                            }.padding()
                            
                        }
                    }
                    .padding(.trailing, -30).buttonStyle(PlainButtonStyle())
                    
                }.onAppear(perform: {
                    UITableView.appearance().separatorStyle = .none
                })
                .background(Color(.blue))
                
                .actionSheet(isPresented: $showActionSheet, content: {
                    actionSheet
                })
                .navigationBarTitle("Your Audio Clips")
            }
            .onAppear {
                UITableView.appearance().separatorStyle = .none
                getAudioClips()
            }
            
            } else {
                EmptySavedView(emptyType: .audioClip)
                .onAppear {
                    getAudioClips()
                }
            }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Remove Clip").font(.title), buttons: [
            .default(Text("Cancel")) {
            },
            .destructive(Text("Delete")) {
                guard let audioClip = audioClip else {
                    return
                }
                
                do {
                    
                    let clips = try Persistence.audioClips.loadItems()
                    guard let clipIndex = clips.firstIndex(of: audioClip) else {
                        print("couldn't find clip")
                        return
                    }
                    try Persistence.audioClips.deleteItem(at: clipIndex)
                } catch {
                    print("error deleting clip: \(error)")
                }
                
                AudioTrim.removeUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime)
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
