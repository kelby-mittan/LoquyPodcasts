//
//  FavoriteView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/7/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import DataPersistence

struct FavoriteView: View {
    
    let episode: Episode
    let artwork: String
    @State var isSaved = false
    @State var saveText = ""
    
    public var episodePersistence = DataPersistence<Episode>(filename: "favEpisodes.plist")
    
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
                    
                    Timer.scheduledTimer(withTimeInterval: 1.75, repeats: false) { (value) in
                        notificationShown = false
                    }
                    
                    if !episodePersistence.hasItemBeenSaved(episode) {
//                        var episodes = UserDefaults.standard.savedEpisodes()
//                        episodes.append(episode)
                        saveText = "remove episode"
                        message = "episode saved"
//                        UserDefaults.standard.saveTheEpisode(episode: episode)
                        
                        
                        do {
                            try episodePersistence.createItem(episode)
                            
                        } catch {
                            print("could not save")
                        }
                        
                        
                        
                        var pCasts = UserDefaults.standard.getPodcastArt()
                        pCasts.append(artwork)
                        UserDefaults.standard.setPodcastArt(pCasts)
                        
                    } else {
                        saveText = "save episode"
                        message = "episode removed"
//                        UserDefaults.standard.deleteEpisode(episode: episode)
                        
                        do {
                            let episodes = try episodePersistence.loadItems()
                            
                            guard let validEpsiode = episodes.firstIndex(of: episode) else { return }
                            
                            try episodePersistence.deleteItem(at: validEpsiode)
                            
                        } catch {
                            print("error getting episodes or deleting episode")
                        }
                        
                        
                        
                        
                        
                        UserDefaults.standard.deletePodcastArt(artwork)
                    }
                    isSaved.toggle()
            }
        }.onAppear {
            if episodePersistence.hasItemBeenSaved(episode) {
                isSaved = true
                saveText = "remove episode"
            } else {
                isSaved = false
                saveText = "save episode"
            }
            
        }
        
    }
}
