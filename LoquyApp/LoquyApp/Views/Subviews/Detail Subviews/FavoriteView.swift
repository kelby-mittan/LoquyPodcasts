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
    
//    @State private var showAlert = false
    
    @Binding var notificationShown: Bool
    @Binding var message: String
    
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text(saveText)
                .fontWeight(.heavy)
                .font(.headline)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
                .onTapGesture {
                    
                    notificationShown.toggle()
                    
                    var timer = 0
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                        timer += 1
                        if timer > 1 {
                            notificationShown = false
                        }
                    }
                    
                    if !isSaved {
                        var episodes = UserDefaults.standard.savedEpisodes()
                        episodes.append(episode)
                        saveText = "remove episode"
                        message = "episode saved"
                        UserDefaults.standard.saveTheEpisode(episode: episode)
                        
                        var pCasts = UserDefaults.standard.getPodcastArt()
                        pCasts.append(artwork)
                        UserDefaults.standard.setPodcastArt(pCasts)
                        
                    } else {
                        saveText = "save episode"
                        message = "episode removed"
                        UserDefaults.standard.deleteEpisode(episode: episode)
                        UserDefaults.standard.deletePodcastArt(artwork)
                    }
                    isSaved.toggle()
            }
        }.onAppear {
            if UserDefaults.standard.savedEpisodes().contains(episode) {
                isSaved = true
                saveText = "remove episode"
            } else {
                isSaved = false
                saveText = "save episode"
            }
            
        }
        
    }
}
