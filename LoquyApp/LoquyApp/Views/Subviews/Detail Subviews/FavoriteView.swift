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
    
    // MARK: injected properties
    
    let episode: Episode
    let artwork: String
    @Binding var notificationShown: Bool
    @Binding var message: String
    @Binding var dominantColor: UIColor?
    @Binding var timestampAlertShown: Bool
    
    // MARK: view properties
    
    @State var isSaved = false
    @State var saveText = RepText.empty
    
    // MARK: functions
    
    private func saveRemoveEpisode() {
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
    }
    
    private func checkEpisodeSaveStatus() {
        if Persistence.episodes.hasItemBeenSaved(episode) {
            isSaved = true
            saveText = RepText.removeEpisode
        } else {
            isSaved = false
            saveText = RepText.saveEpisode
        }
    }
    
    private func handleNotificationBanner() {
        notificationShown.toggle()

        Timer.scheduledTimer(withTimeInterval: 1.75, repeats: false) { (value) in
            notificationShown = false
        }
    }
    
    var body: some View {
        
        Button(action: {
            
            handleNotificationBanner()
            saveRemoveEpisode()
            withAnimation {
                isSaved.toggle()
            }
            
        }) {
            ZStack {
                NeoButtonView(dominantColor: $dominantColor)
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.body.bold())
                    .foregroundColor(Color(dominantColor ?? .white))
            }
            .opacity(timestampAlertShown ? 0 : 1)
            .frame(width: 40, height: 40)
            .clipShape(Capsule())
        }
        .onAppear(perform: checkEpisodeSaveStatus)
    }
    
}
