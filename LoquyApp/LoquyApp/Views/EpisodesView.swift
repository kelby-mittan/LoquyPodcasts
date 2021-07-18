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
    
    @ObservedObject var viewModel = ViewModel.shared
        
    @State public var title: String
    public let podcastFeed: String?
    public let isSaved: Bool
    public let artWork: String

    @State var episode: Episode?
    @State var color = UIColor(Color.gray)
    
    var body: some View {
        if viewModel.episodes.isEmpty {
            VStack {
                ActivityIndicator(style: .large)
                    .padding(.top,40)
                    .onAppear {
                        isSaved
                            ? viewModel.episodes = viewModel.loadFavoriteEpisodes(&title)
                            : viewModel.loadEpisodes(feedUrl: podcastFeed ?? RepText.empty)
                        UITableView.appearance().separatorStyle = .none
                }
                Spacer()
            }
            .navigationBarTitle(title)
        } else {
            List(viewModel.episodes, id: \.self) { episode in
                
                NavigationLink(destination: EpisodeDetailView(episode: episode, artwork: artWork, feedUrl: podcastFeed, isDeepLink: false)) {
                    
                    ZStack(alignment: .center) {
                        ZStack {
                            Color(viewModel.imageColor ?? UIColor(Color.gray))
                        }
                        .cornerRadius(12)
                        .padding(.trailing)
                        
                        HStack(alignment: .top) {
                            
                            RemoteImage(url: episode.imageUrl ?? RepText.empty)
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
                    .padding(.horizontal)
                    .cornerRadius(12)
                    .onAppear {
//                        viewModel.getDomColor(episode.imageUrl ?? RepText.empty) { color in
//                            DispatchQueue.main.async {
//                                self.color = color
//                            }
//                        }
                    }
                    
                }
//                .frame(height: UIScreen.main.bounds.height/6)
                .padding(.trailing, -30)
                .buttonStyle(PlainButtonStyle())
            }
            .onAppear {
                isSaved
                    ? viewModel.episodes = viewModel.loadFavoriteEpisodes(&title)
                    : viewModel.loadEpisodes(feedUrl: podcastFeed ?? RepText.empty)
                                
                viewModel.getEpisodeForDomColor()
                
                UITableView.appearance().separatorStyle = .none
            }
            .navigationBarTitle(title)
        }
        
    }
    
}

