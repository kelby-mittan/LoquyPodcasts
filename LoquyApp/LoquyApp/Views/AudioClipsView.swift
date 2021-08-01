//
//  AudioClipsView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)

struct AudioClipsView: View {
    
    @ObservedObject var viewModel = ViewModel.shared
    
    
    @State var showActionSheet: Bool = false
    @State var audioClip: AudioClip?
    
    var body: some View {
        
        if !viewModel.audioClips.isEmpty {
            NavigationView {
                List(viewModel.audioClips, id: \.self) { clip in
                    
                    NavigationLink(destination: TranscribeView(audioClip: clip)) {
                        
                        
                        ClipListItem(clip: clip, showActionSheet: $showActionSheet, audioClip: $audioClip)
                        
                        
                    }
                    .padding(.trailing, -30).buttonStyle(PlainButtonStyle())
                    
                }
                .actionSheet(isPresented: $showActionSheet, content: {
                    actionSheet
                })
                .navigationBarTitle(LoquynClipText.yourClips)
            }
            .onAppear {
                UITableView.appearance().separatorStyle = .none
                getAudioClips()
            }
            .accentColor(.purple)
            
        } else {
            EmptySavedView(emptyType: .audioClip)
                .onAppear {
                    getAudioClips()
                }
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text(LoquynClipText.removeClip).font(.title), buttons: [
            .default(Text(LoquynClipText.cancel)) {
            },
            .destructive(Text(LoquynClipText.delete)) {
                guard let audioClip = audioClip else {
                    return
                }
                
                do {
                    
                    let clips = try Persistence.audioClips.loadItems()
                    guard let clipIndex = clips.firstIndex(of: audioClip) else {
                        return
                    }
                    try Persistence.audioClips.deleteItem(at: clipIndex)
                } catch {
                    print(error.localizedDescription)
                }
                
                AudioTrim.removeUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime)
                getAudioClips()
            }
        ])
    }
    
    func getAudioClips() {
        viewModel.loadAudioClips()
    }
}

struct ClipListItem: View {
    
    @ObservedObject var viewModel = ViewModel.shared
    @State var clip: AudioClip
    @Binding var showActionSheet: Bool
    @Binding var audioClip: AudioClip?
    
    @State var domColor: UIColor?
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack {
                Color(domColor ?? .lightGray)
                
            }
            .cornerRadius(12)
            .padding(.trailing)
            
            VStack {
                
                HStack {
                    RemoteImage(url: clip.episode.imageUrl ?? RepText.empty, domColorReporter: $viewModel.domColorReporter)
                        .frame(width: 120, height: 120)
                        .cornerRadius(6)
                        .onLongPressGesture {
                            audioClip = clip
                            showActionSheet.toggle()
                        }
                    
                    Spacer()
                    
                    VStack(alignment:.center) {
                        
                        Text(clip.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .padding([.top,.bottom],8)
                        
                        Text(clip.savedDate)
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                    }
                    .padding(.trailing)
                    Spacer()
                }
                
                Text(clip.episode.title)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                
                
            }
            .padding()
            
            
        }
        .onAppear {
            viewModel.getDomColor(clip.episode.imageUrl ?? RepText.empty) { clr in
                domColor = clr
            }
        }

    }
}

@available(iOS 14.0, *)
struct AudioClipsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioClipsView()
    }
}
