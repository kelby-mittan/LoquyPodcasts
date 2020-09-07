//
//  FavoriteView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/7/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
    
    let episode: Episode
    let artwork: String
    @State var isSaved = false
    @State var saveText = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text(saveText)
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
                .onTapGesture {
                    
                    
                    if !self.isSaved {
                        var episodes = UserDefaults.standard.savedEpisodes()
                        episodes.append(self.episode)
                        self.saveText = "Remove Episode"
                        UserDefaults.standard.saveTheEpisode(episode: self.episode)
                        
                        var pCasts = UserDefaults.standard.getPodcastArt()
                        pCasts.append(self.artwork)
                        UserDefaults.standard.setPodcastArt(pCasts)
                        
                    } else {
                        self.saveText = "Save Episode"
                        UserDefaults.standard.deleteEpisode(episode: self.episode)
                        UserDefaults.standard.deletePodcastArt(self.artwork)
                    }
                    self.isSaved.toggle()
            }
        }.onAppear {
            if UserDefaults.standard.savedEpisodes().contains(self.episode) {
                self.isSaved = true
                self.saveText = "Remove Episode"
            } else {
                self.isSaved = false
                self.saveText = "Save Episode"
            }
            
        }
        
    }
}
