//
//  EpisodesView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct EpisodesView: View {
        
    @EnvironmentObject var viewModel: ViewModel
    
    // MARK: injected properties
    
    @State public var title: String
    public let podcastFeed: String?
    public let isSaved: Bool
    public let artWork: String
    
    @State var episode: Episode?
    @State var dominantColor: UIColor?
    
    @State var navToDetail: Bool = false
        
    var body: some View {
        if viewModel.episodes.isEmpty {
            VStack {
                ActivityIndicator(style: .large)
                    .padding(.top,40)
                    .onAppear {
                        isSaved
                        ? viewModel.episodes = viewModel.loadFavoriteEpisodes(&title)
                        : viewModel.loadEpisodes(feedUrl: podcastFeed ?? RepText.empty)
                    }
                Spacer()
            }
            .navigationBarTitle(title)
        } else {
            
            List(viewModel.episodes, id: \.self) { episode in

                ZStack {
                    
                    EpisodeListItemView(episode: episode, dominantColor: dominantColor ?? .lightGray)
                    
                    NavigationLink(destination: EpisodeDetailView(episode: episode,
                                                                  artwork: artWork,
                                                                  feedUrl: podcastFeed,
                                                                  isDeepLink: false,
                                                                  dominantColor: dominantColor ?? .lightGray)
                                    .environmentObject(viewModel)) {
                        EmptyView()
                    }

                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.grouped)
            .navigationBarTitle(title)
            .onAppear {
                isSaved
                ? viewModel.episodes = viewModel.loadFavoriteEpisodes(&title)
                : viewModel.loadEpisodes(feedUrl: podcastFeed ?? RepText.empty)
                
                getDominantColor()
                
            }
            .onDisappear {
                viewModel.episodes = []
            }
            
        }
        
    }
    
    func getDominantColor() {
        if let firstEpisodeImg = viewModel.episodes.first?.imageUrl {
            viewModel.getDominantColor(firstEpisodeImg) { clr in
                if clr.isDark() {
                    dominantColor = clr
                } else {
                    dominantColor = .lightGray
                }
            }
        }
    }
    
}

struct EpisodeListItemView: View {
    @State var episode: Episode
    @State var dominantColor: UIColor
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(dominantColor)

            HStack {

                RemoteImage(url: episode.imageUrl ?? RepText.empty)
                    .frame(width: 120, height: 120)
                    .cornerRadius(6)
                    .padding(.vertical)

                VStack(alignment: .leading) {

                    Text(episode.pubDate.makeString())
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .padding(.bottom,4)

                    Text(episode.title)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .fontWeight(.semibold)
                        .lineLimit(4)

                    Spacer()

                }
                .padding()
            }
            .padding()
        }
        .cornerRadius(12)
    }
}
