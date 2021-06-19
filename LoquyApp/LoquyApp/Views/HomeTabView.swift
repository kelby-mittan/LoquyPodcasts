//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
@main
struct Home: App {
    @State private var selectedTab = 0
    @ObservedObject private var networkManager = ViewModel()
    @State private var isDeepLink = false
    @State private var hasLoaded = false
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var deepLinkEpisode = Episode(url: URL(string: RepText.empty))
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                Group {
                    if !isDeepLink {
                        BrowseView()
                    } else {
                        NavigationView {
                            EpisodeDetailView(episode: deepLinkEpisode, artwork: deepLinkEpisode.imageUrl ?? RepText.empty, feedUrl: deepLinkEpisode.feedUrl, isDeepLink: true)
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
                //                print("URL TO PARSE")
                //                print(url.absoluteString)
                //                let components = url.absoluteString.components(separatedBy: "loquyApp")
                //
                //                dump(components)
                //                guard components.count == 4 else { return }
                //                let feed = components[1].replacingOccurrences(of: "https//", with: "https://")
                //                let pubDate = components[2].removingPercentEncoding ?? ""
                //                let timeStamp = components[3].removingPercentEncoding ?? ""
                //                print(feed)
                //                print(pubDate)
                //                print(timeStamp)
                
                let deepLinkData = url.getURLComponents()
                
                ITunesAPI.shared.fetchSpecificEpisode(feedUrl: deepLinkData.feed, date: deepLinkData.pubDate) { episode in
                    DispatchQueue.main.async {
                        deepLinkEpisode = episode
                        deepLinkEpisode.deepLinkTime = deepLinkData.dlTime
                        dump(deepLinkEpisode)
                        isDeepLink = true
                    }
                }
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
    @ObservedObject private var viewModel = ViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
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
    
    @ObservedObject private var networkManager = ViewModel()
    
    var body: some View {
        
        if !networkManager.favorites.isEmpty {
            NavigationView {
                FavoritesVCWrapper()
                    .navigationBarHidden(true)
            }
            .onAppear {
                networkManager.loadFavorites()
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
                    networkManager.loadFavorites()
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


