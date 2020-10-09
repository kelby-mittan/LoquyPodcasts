//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @State private var selectedTab = 0
    @ObservedObject private var networkManager = NetworkingManager()
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
       
        TabView(selection: $selectedTab) {
            BrowseView().tag(1)
            FavoritesTabView().tag(2)
            AudioClipsTab().tag(3)
            TranscriptsTab().tag(4)
        }
        .onAppear(perform: {
            UITabBar.appearance().isHidden = false
        })
                
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct BrowseView: View {
    @State private var searchText = ""
    @State private var isPodcastShowing = true
    @State private var isEditing = false
    @ObservedObject private var networkManager = NetworkingManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    let mindcast = DummyPodcast.podcasts[6]
    
    var body: some View {
        
        NavigationView {
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
        }.onAppear {
            Player.setupAudioSession()
        }
        
        .tabItem {
            Image(systemName: "magnifyingglass")
                .font(.body)
            Text("Browse")
        }
    }
    
    
    func loadPodcasts(search: String) {
        networkManager.updatePodcasts(forSearch: searchText)
    }
}

struct FavoritesTabView: View {
    var body: some View {
        NavigationView {
            FavoritesVCWrapper()
        .navigationBarTitle("")
        .navigationBarHidden(true)
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

struct AudioClipsTab: View {
    var body: some View {
        AudioClipsView()
            .tabItem {
                
                Image(systemName: "textbox")
                    .font(.body)
                    .padding(.top, 16.0)
                Text("Transcribe")
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


