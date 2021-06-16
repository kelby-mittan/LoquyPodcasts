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
    @ObservedObject private var networkManager = NetworkingManager()
    @State private var isDeepLink = false
    @State private var hasLoaded = false
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var deepLinkEpisode = Episode(url: URL(string: ""))
    @State var deepLinkEpisodeFeed = ""
    @State var deepLinkEpisodeDate = ""
    @State var deepLinkEpisodeTimeStamp = ""
    
    var homeView: some View {
        TabView(selection: $selectedTab) {
            BrowseView().tag(1)
            FavoritesTabView().tag(2)
            AudioClipsTab().tag(3)
            TranscriptsTab().tag(4)
        }
        .accentColor(.purple)
        .onAppear {
            UITabBar.appearance().isHidden = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
        
            TabView(selection: $selectedTab) {
                Group {
                    if !isDeepLink {
                        BrowseView()
                            .onAppear {
                                ITunesAPI.shared.fetchSpecificEpisode(feedUrl: "https://originspodcast.libsyn.com/rss", date: "2021-06-02 03:46:05 +0000") { episode in
                                    DispatchQueue.main.async {
                                        dump(episode)
//                                        isDeepLink = true
                                    }
                                }
                            }
                    } else {
                        EpisodeDetailView(episode: deepLinkEpisode, artwork: deepLinkEpisode.imageUrl ?? "", feedUrl: deepLinkEpisode.feedUrl)
                        
                    }
                }.tag(1)
                FavoritesTabView().tag(2)
                AudioClipsTab().tag(3)
                TranscriptsTab().tag(4)
            }
            .accentColor(.purple)
            .onAppear {
                UITabBar.appearance().isHidden = false
            }
            .onOpenURL(perform: { url in
//                let episode = Episode(url: url)
//                theEpisode = episode
                print("URL TO PARSE")
                print(url.absoluteString)
                let components = url.absoluteString.components(separatedBy: "loquyApp")

                dump(components)
                guard components.count == 4 else { return }
                let feed = components[1].replacingOccurrences(of: "https//", with: "https://")
                let pubDate = components[2].removingPercentEncoding ?? ""
                let timeStamp = components[3].removingPercentEncoding ?? ""
                print(feed)
                print(pubDate)
                print(timeStamp)
                deepLinkEpisodeFeed = feed
                deepLinkEpisodeDate = pubDate
                deepLinkEpisodeTimeStamp = timeStamp
//                isDeepLink = true
                
                ITunesAPI.shared.fetchSpecificEpisode(feedUrl: feed, date: pubDate) { episode in
                    DispatchQueue.main.async {
                        deepLinkEpisode = episode
                        deepLinkEpisode.deepLinkTime = timeStamp
                        dump(deepLinkEpisode)
//                        hasLoaded = true
                        isDeepLink = true
                    }
                }
            })
        }
        
    }
}

struct BrowseView: View {
    
//    @Binding var isDeepLink: Bool
    
    @State private var searchText = ""
    @State private var isPodcastShowing = true
    @State private var isEditing = false
    @ObservedObject private var networkManager = NetworkingManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    let mindcast = DummyPodcast.podcasts[6]
    
    var body: some View {
        
        NavigationView {
//            if !isDeepLink {
                VStack {
                    SearchBar(text: $searchText, onTextChanged: loadPodcasts(search:), isEditing: $isEditing)
                        .padding([.leading,.trailing])
                    Group {
                        if searchText.isEmpty {
                            
                            ScrollView(.vertical) {
                                HeaderView(label: "Listen To")
                                NavigationLink(destination: EpisodesView(title: mindcast.title, podcastFeed: mindcast.feedUrl, isSaved: false, artWork: mindcast.image)) {
                                    ListenToView()
                                }
                                PodcastScrollView()
                                FeaturedView()
                                HeaderView(label: "More Cool Casts")
                                MoreCastsView()
                            }
                            
                        } else {
                            List(networkManager.podcasts, id: \.self) { podcast in
                                NavigationLink(destination: EpisodesView(title: podcast.trackName ?? "", podcastFeed: podcast.feedUrl ?? "", isSaved: false, artWork: podcast.artworkUrl600 ?? "")) {
                                    RemoteImage(url: podcast.artworkUrl600 ?? "")
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading) {
                                        Text(podcast.trackName ?? "")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        Text(podcast.artistName ?? "")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text("\(podcast.trackCount ?? 0) episodes")
                                            .font(.caption)
                                            .fontWeight(.light)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
//            } else {
//
//            }
            
        }
        .accentColor(.purple)
        .onAppear {
            Player.setupAudioSession()
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
                .font(.body)
            Text("Browse")
        }
    }
    
    
    private func loadPodcasts(search: String) {
        var timer: Timer?
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { (_) in
            networkManager.updatePodcasts(forSearch: searchText)
        })
    }
}

struct FavoritesTabView: View {
    
    @ObservedObject private var networkManager = NetworkingManager()
    @State var episodes: [Episode] = []
    
    var body: some View {
        
        if !episodes.isEmpty {
            NavigationView {
                FavoritesVCWrapper()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
            .onAppear {
                getFavs()
            }
            .accentColor(.purple)
            .tabItem {
                Image(systemName: "star.fill")
                    .font(.body)
                    .padding(.top, 16.0)
                    .foregroundColor(.purple)
                Text("Favorites")
            }
        } else {
            EmptySavedView(emptyType: .favorite)
                .onAppear {
                    getFavs()
                }
                .tabItem {
                    Image(systemName: "star.fill")
                        .font(.body)
                        .padding(.top, 16.0)
                        .foregroundColor(.purple)
                    Text("Favorites")
                }
        }
        
    }
    
    private func getFavs() {
        do {
            episodes = try Persistence.episodes.loadItems()
        } catch {
            print("error getting episodes: \(error)")
        }
    }
    
}

struct AudioClipsTab: View {
    var body: some View {
        AudioClipsView()
            .tabItem {
                
                Image(systemName: "speaker.2.fill")
                    .font(.body)
                    .padding(.top, 16.0)
                Text("Audio Clips")
            }
    }
}

struct TranscriptsTab: View {
    var body: some View {
        if #available(iOS 14.0, *) {
            LoquyListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                        .font(.body)
                        .padding(.top, 16.0)
                    Text("Loquies")
                }
        } else {
            Text("Upgrade to iOS 14")
                .tabItem {
                    Image(systemName: "list.bullet")
                        .font(.body)
                        .padding(.top, 16.0)
                    Text("Loquies")
                }
        }
    }
}


