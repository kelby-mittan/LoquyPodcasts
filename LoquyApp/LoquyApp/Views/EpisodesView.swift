//
//  EpisodesView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct EpisodesView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State public var title: String
    public let podcastFeed: String?
    public let isSaved: Bool
    public let artWork: String
    
    @State var episode: Episode?
    @State var domColor: UIColor?
    
    @State var navigateToDetail = false
    
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
                    
                    NavigationLink(isActive: $navigateToDetail) {
                        EpisodeDetailView(episode: episode,
                                          artwork: artWork,
                                          feedUrl: podcastFeed,
                                          isDeepLink: false,
                                          domColor: domColor ?? .lightGray)
                            .environmentObject(viewModel)
                    } label: {
                        EmptyView()
                    }

                    EpisodeListItemView(episode: episode, domColor: domColor ?? .lightGray)

                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.grouped)
            .onChange(of: viewModel.episodes, perform: { _ in
                if let firstEpisodeImg = viewModel.episodes.first?.imageUrl {
                    viewModel.getDomColor(firstEpisodeImg) { clr in
                        if clr.isDark() {
                            domColor = clr
                        } else {
                            domColor = .lightGray
                        }

                    }
                }
            })
            
            .onAppear {
                isSaved
                ? viewModel.episodes = viewModel.loadFavoriteEpisodes(&title)
                : viewModel.loadEpisodes(feedUrl: podcastFeed ?? RepText.empty)
                
                if let firstEpisodeImg = viewModel.episodes.first?.imageUrl {
                    viewModel.getDomColor(firstEpisodeImg) { clr in
                        if clr.isDark() {
                            domColor = clr
                        } else {
                            domColor = .lightGray
                        }
                    }
                }
                                
            }
            .navigationBarTitle(title)
            .onDisappear {
                if !navigateToDetail && viewModel.selectedTab == 0 {
                    viewModel.episodes = []
                }
                
            }
        }
        
    }
    
}

struct EpisodeListItemView: View {
    @State var episode: Episode
    @State var domColor: UIColor
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(domColor)

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
