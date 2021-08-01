//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct Home: App {
    
    @ObservedObject private var deepLinkViewModel = DeepLinkViewModel()
    
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                Group {
                    if !deepLinkViewModel.isDeepLink {
                        BrowseView()
                    } else {
                        NavigationView {
                            EpisodeDetailView(episode: deepLinkViewModel.deepLinkEpisode, artwork: deepLinkViewModel.deepLinkEpisode.imageUrl ?? RepText.empty, feedUrl: deepLinkViewModel.deepLinkEpisode.feedUrl, isDeepLink: true)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: Symbol.magGlass)
                        .font(.body)
                    Text(HomeText.browse)
                }.tag(1)
                FavoritesTabView().tag(2)
                AudioClipsTab().tag(3)
                TranscriptsTab().tag(4)
            }
            .onOpenURL { url in
                deepLinkViewModel.loadDeepLinkEpisode(url: url)
            }
            .accentColor(.purple)
            
        }
        
    }
}

@available(iOS 14.0, *)
struct BrowseView: View {
    
    @State private var searchText = RepText.empty
    @State private var isPodcastShowing = true
    @State private var isEditing = false
    @ObservedObject private var viewModel = ViewModel.shared
        
    let mindspace = DummyPodcast.mindspace
    
    var body: some View {
        
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onTextChanged: viewModel.loadSearchPodcasts(search:), isEditing: $isEditing)
                    .padding([.leading,.trailing])
                Group {
                    if searchText.isEmpty {
                        
                        ScrollView(.vertical) {
                            HeaderView(label: HomeText.listenTo)
                            NavigationLink(destination: EpisodesView(title: mindspace.title, podcastFeed: mindspace.feedUrl, isSaved: false, artWork: mindspace.image)) {
                                ListenToView()
                            }
                            PodcastScrollView()
                            FeaturedView()
                            HeaderView(label: HomeText.moreCasts)
                            MoreCastsView()
                        }
                        
                    } else {
                        List(viewModel.podcasts, id: \.self) { podcast in
                            NavigationLink(destination: EpisodesView(title: podcast.trackName ?? RepText.empty, podcastFeed: podcast.feedUrl ?? RepText.empty, isSaved: false, artWork: podcast.artworkUrl600 ?? RepText.empty)) {
                                RemoteImage(url: podcast.artworkUrl600 ?? RepText.empty, domColorReporter: $viewModel.domColorReporter)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(podcast.trackName ?? RepText.empty)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(podcast.artistName ?? RepText.empty)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("\(podcast.trackCount ?? 0)"+HomeText.episodes)
                                        .font(.caption)
                                        .fontWeight(.light)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(RepText.empty)
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        .accentColor(.purple)
        .onAppear {
            Player.setupAudioSession()
        }
        
    }
}

@available(iOS 14.0, *)
struct FavoritesTabView: View {
    
    @ObservedObject private var viewModel = ViewModel.shared
    
    var body: some View {
        
        if !viewModel.favorites.isEmpty {
            NavigationView {
                FavoritesVCWrapper()
                    .navigationBarHidden(true)
            }
            .onAppear {
                viewModel.loadFavorites()
            }
            .accentColor(.purple)
            .tabItem {
                Image(systemName: Symbol.star)
                    .font(.body)
                    .padding(.top, 16.0)
                    .foregroundColor(.purple)
                Text(HomeText.favorites)
            }
        } else {
            EmptySavedView(emptyType: .favorite)
                .onAppear {
                    viewModel.loadFavorites()
                }
                .tabItem {
                    Image(systemName: Symbol.star)
                        .font(.body)
                        .padding(.top, 16.0)
                        .foregroundColor(.purple)
                    Text(HomeText.favorites)
                }
        }
        
    }
    
}

@available(iOS 14.0, *)
struct AudioClipsTab: View {
    var body: some View {
        AudioClipsView()
            .tabItem {
                Image(systemName: Symbol.speaker)
                    .font(.body)
                    .padding(.top, 16.0)
                Text(HomeText.clips)
            }
    }
}

@available(iOS 14.0, *)
struct TranscriptsTab: View {
    var body: some View {
        LoquyListView()
            .tabItem {
                Image(systemName: Symbol.bullet)
                    .font(.body)
                    .padding(.top, 16.0)
                Text(HomeText.loquies)
            }
    }
}


