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
    @Binding var notificationShown: Bool
    @Binding var message: String
    @Binding var domColor: UIColor?
    
    @State var isSaved = false
    @State var saveText = RepText.empty
    
    var body: some View {
        
        Button(action: {
            
            notificationShown.toggle()

            Timer.scheduledTimer(withTimeInterval: 1.75, repeats: false) { (value) in
                notificationShown = false
            }

            if !Persistence.episodes.hasItemBeenSaved(episode) {
                saveText = RepText.removeEpisode
                message = RepText.episodeSaved
                do {
                    try Persistence.episodes.createItem(episode)
                    try Persistence.artWork.createItem(artwork)
                } catch {
                    print(error.localizedDescription)
                }

            } else {
                saveText = RepText.saveEpisode
                message = RepText.episodeRemoved

                do {
                    let episodes = try Persistence.episodes.loadItems()
                    let artWorks = try Persistence.artWork.loadItems()

                    guard let validEpsiode = episodes.firstIndex(of: episode) else {
                        return
                    }
                    try Persistence.episodes.deleteItem(at: validEpsiode)

                    guard let art = artWorks.firstIndex(of: artwork) else {
                        return
                    }
                    try Persistence.artWork.deleteItem(at: art)

                } catch {
                    print(error.localizedDescription)
                }
            }
            isSaved.toggle()
            
            
        }) {
            Text(saveText)
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(Color(domColor ?? .lightGray))
                .background(NeoButtonView(domColor: $domColor))
                .clipShape(Capsule())
                .padding()
        }
        .onAppear {
            if Persistence.episodes.hasItemBeenSaved(episode) {
                isSaved = true
                saveText = RepText.removeEpisode
            } else {
                isSaved = false
                saveText = RepText.saveEpisode
            }
        }
    }
}
