//
//  EpisodesView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct EpisodesView: View {
    
    @ObservedObject private var networkManager = NetworkingManager()
    
    @State var title: String
    let podcastFeed: String?
    let isSaved: Bool
    let artWork: String
    
    @State var halfModalShown = false
    
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    var body: some View {
        if networkManager.episodes.isEmpty {
            VStack {
                ActivityIndicator(style: .large)
                    .padding(.top,40)
                    .onAppear {
                        isSaved ? networkManager.episodes = getFavorites() : getPodcasts()
                        UITableView.appearance().separatorStyle = .none
                }
                Spacer()
            }
            .navigationBarTitle(title)
        } else {
            List(networkManager.episodes, id: \.self) { episode in
                
                NavigationLink(destination: EpisodeDetailView(episode: episode, artwork: artWork)) {
                    
                    ZStack(alignment: .leading) {
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
                        
                        HStack(alignment: .top) {
                            
                            RemoteImage(url: episode.imageUrl ?? "")
                                .frame(width: 110, height: 110)
                                .cornerRadius(6)
                                .padding([.leading,.bottom,.top])
                            
                            VStack(alignment: .leading) {
                                
                                Text(episode.pubDate.makeString())
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
                                    .padding()
                                
                                Text(episode.title)
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                                    .padding([.horizontal])
                            }
                        }
                        .padding()
                    }
                }
                .padding(.trailing, -30).buttonStyle(PlainButtonStyle())
            }.onAppear {
                isSaved ? networkManager.episodes = getFavorites() : getPodcasts()
                UITableView.appearance().separatorStyle = .none
            }
            .navigationBarTitle(title)
        }
        
    }
    
    private func getPodcasts() {
        networkManager.loadEpisodes(feedUrl: podcastFeed ?? "")
    }
    
    private func getFavorites() -> [Episode] {
        var episodes: [Episode] = []
        
        do {
            episodes = try Persistence.episodes.loadItems().filter { $0.author == title }
        } catch {
            print("error getting episodes: \(error)")
        }
        
        title = episodes.first?.author ?? "NOOOOO"
        return episodes
    }
    
}

