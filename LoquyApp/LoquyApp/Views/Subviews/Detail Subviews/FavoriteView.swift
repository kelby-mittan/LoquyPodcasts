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
    
//    @State private var showAlert = false
    
    @Binding var notificationShown: Bool
    @Binding var message: String
    
    var body: some View {
//        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text(saveText)
                .fontWeight(.heavy)
                .font(.headline)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.purple)
                .background(NeoButtonView())
                .clipShape(Capsule())
                .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 16, x: 10, y: 10)
                .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
                .padding()
                .onTapGesture {
                    
                    notificationShown.toggle()
                    
                    Timer.scheduledTimer(withTimeInterval: 1.75, repeats: false) { (value) in
                        notificationShown = false
                    }
                    
                    if !Persistence.episodes.hasItemBeenSaved(episode) {
//                        var episodes = UserDefaults.standard.savedEpisodes()
//                        episodes.append(episode)
//                        UserDefaults.standard.saveTheEpisode(episode: episode)
                        saveText = "remove episode"
                        message = "episode saved"
                        do {
                            try Persistence.episodes.createItem(episode)
                            try Persistence.artWork.createItem(artwork)
                        } catch {
                            print("could not save episode/ artwork")
                        }
                        
//                        var pCasts = UserDefaults.standard.getPodcastArt()
//                        pCasts.append(artwork)
//                        UserDefaults.standard.setPodcastArt(pCasts)
                        
                    } else {
                        saveText = "save episode"
                        message = "episode removed"
//                        UserDefaults.standard.deleteEpisode(episode: episode)
                        
                        do {
                            let episodes = try Persistence.episodes.loadItems()
                            let artWorks = try Persistence.artWork.loadItems()
                            
                            guard let validEpsiode = episodes.firstIndex(of: episode) else {
                                print("couldn't get episode")
                                return
                            }
                            try Persistence.episodes.deleteItem(at: validEpsiode)
                            
                            guard let art = artWorks.firstIndex(of: artwork) else {
                                print("couldn't get art")
                                return
                            }
                            try Persistence.artWork.deleteItem(at: art)
                            
                        } catch {
                            print("error getting episodes or deleting episode/ art")
                        }
                        
//                        UserDefaults.standard.deletePodcastArt(artwork)
                    }
                    isSaved.toggle()
//            }
        }.onAppear {
            if Persistence.episodes.hasItemBeenSaved(episode) {
                isSaved = true
                saveText = "remove episode"
            } else {
                isSaved = false
                saveText = "save episode"
            }
            
        }
        
    }
}
