//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@main
struct Home: App {
    
    @StateObject var viewModel = ViewModel()
    @StateObject var deepLinkViewModel = DeepLinkViewModel()
    
    @State var deepLinkDominantColor: UIColor?
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $viewModel.selectedTab) {
                Group {
                    if !deepLinkViewModel.isDeepLink {
                        BrowseView()
                            .environmentObject(viewModel)
                            
                    } else {
                        NavigationView {
                            EpisodeDetailView(episode: deepLinkViewModel.deepLinkEpisode,
                                              artwork: deepLinkViewModel.deepLinkEpisode.imageUrl ?? RepText.empty,
                                              feedUrl: deepLinkViewModel.deepLinkEpisode.feedUrl,
                                              isDeepLink: true,
                                              dominantColor: deepLinkDominantColor ?? .lightGray)
                                .environmentObject(viewModel)
                        }
                        .navigationViewStyle(.stack)
                    }
                }
                .tabItem {
                    Image(systemName: Symbol.magGlass)
                        .font(.body)
                    Text(HomeText.browse)
                }
                .tag(1)
                
                FavoritesTabView()
                    .environmentObject(viewModel)
                    .tag(2)
                AudioClipsTab()
                    .environmentObject(viewModel)
                    .tag(3)
                TranscriptsTab()
                    .environmentObject(viewModel)
                    .environmentObject(deepLinkViewModel)
                    .tag(4)
            }
            .onOpenURL { url in
                deepLinkViewModel.loadDeepLinkEpisode(url: url)
            }
            .accentColor(.purple)
        }
        
        
    }
}

struct BrowseView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var searchText = RepText.empty
    @State private var isEditing = false
    
    let mindspace = DummyPodcast.mindspace
    
    var body: some View {
        
        NavigationView {
            VStack {
                Group {
                    if searchText.isEmpty {
                        
                        ScrollView(.vertical) {
                            HeaderView(label: HomeText.listenTo)
                            NavigationLink(destination: EpisodesView(title: mindspace.title,
                                                                     podcastFeed: mindspace.feedUrl,
                                                                     isSaved: false,
                                                                     artWork: mindspace.image).environmentObject(viewModel)) {
                                ListenToView()
                            }
                            PodcastScrollView()
                            FeaturedView()
                            HeaderView(label: HomeText.moreCasts)
                            MoreCastsView()
                        }
                        
                    } else {
                        List(viewModel.podcasts, id: \.self) { podcast in
                            NavigationLink(destination:
                                            EpisodesView(title: podcast.trackName ?? RepText.empty,
                                                         podcastFeed: podcast.feedUrl ?? RepText.empty,
                                                         isSaved: false,
                                                         artWork: podcast.artworkUrl600 ?? RepText.empty)
                                            .environmentObject(viewModel)
                            )
                            {
                                RemoteImage(url: podcast.artworkUrl600 ?? RepText.empty)
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
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { newValue in
                viewModel.loadSearchPodcasts(search: newValue)
            })
            .navigationBarTitle(RepText.empty)
        }
        .animation(.default, value: searchText.isEmpty)
        .accentColor(.secondary)
        
    }
}

struct FavoritesTabView: View {
    
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        
        if !viewModel.favorites.isEmpty {
            NavigationView {
                FavoritesVCWrapper()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(.stack)
            .onAppear {
                viewModel.loadFavorites()
            }
            .accentColor(.secondary)
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

struct AudioClipsTab: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        AudioClipsView()
            .environmentObject(viewModel)
            .tabItem {
                Image(systemName: Symbol.speaker)
                    .font(.body)
                    .padding(.top, 16.0)
                Text(HomeText.clips)
            }
    }
}

struct TranscriptsTab: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var deepLinkViewModel: DeepLinkViewModel
    var body: some View {
        LoquyListView()
            .environmentObject(viewModel)
            .environmentObject(deepLinkViewModel)
            .tabItem {
                Image(systemName: Symbol.bullet)
                    .font(.body)
                    .padding(.top, 16.0)
                Text(HomeText.loquies)
            }
    }
}


