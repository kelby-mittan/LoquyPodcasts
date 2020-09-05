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
    
    let title: String
    let podcastFeed: String?
    let isSaved: Bool
    
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    var body: some View {
        
        VStack {
            List(networkManager.episodes, id: \.self) { episode in
                
                NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                    
                    ZStack(alignment: .leading) {
                        LinearGradient(gradient: Gradient(colors: [self.gradColor1!, self.gradColor2!]), startPoint: .top, endPoint: .bottomTrailing)
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
                
            }.onAppear(perform: {
                UITableView.appearance().separatorStyle = .none
//                if self.isSaved {
//                    self.networkManager.episodes = UserDefaults.standard.savedEpisodes().filter { $0.imageUrl == self.title }
//                } else {
//                    self.getPodcasts()
//                }
                
                self.isSaved ? self.networkManager.episodes = UserDefaults.standard.savedEpisodes().filter { $0.imageUrl == self.title } : self.getPodcasts()
            })
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(title)
        }
    }
    
    func getPodcasts() {
        networkManager.loadEpisodes(feedUrl: podcastFeed ?? "")
    }
    
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView(title: "Yang Speaks", podcastFeed: "https://feeds.megaphone.fm/yang-speaks", isSaved: false)
    }
}
