//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

struct BrowseView: View {
    
    //    init () {
    //        UITabBar.appearance().backgroundColor = UIColor.green
    //    }
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TabOne().tag(1)
            TabTwo().tag(2)
            TabThree().tag(3)
        }
        .padding(.bottom, 0)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}

struct PodcastPosterView: View {
    let podcast: DummyPodcast
    let width: CGFloat
    let height: CGFloat
    
    init(podcast: DummyPodcast, width: CGFloat, height: CGFloat) {
        self.podcast = podcast
        self.width = width
        self.height = height
    }
    var body: some View {
        Image(podcast.image)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .cornerRadius(12)
            .padding()
    }
}

struct TabOne: View {
    @State private var searchText = ""
    //    @ObservedObject private var viewModel = PodcastViewModel()
    @State private var isPodcastShowing = true
    
    @ObservedObject private var networkManager = NetworkingManager()
    
    var body: some View {
        
        Group {
            if searchText.isEmpty {
                NavigationView {
                    VStack {
                        
                        SearchBar(text: $searchText, onTextChanged: loadPodcasts(search:))
                            .padding([.leading,.trailing])
                        
                        ScrollView(.vertical) {
                            HeaderView(label: "Listen To")
                            NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.podcasts[6])) {
                                ListenToView(isPodcastShowing: $isPodcastShowing)
                            }
                            PodcastScrollView()
                            
                            FeaturedView()
                            
                            HeaderView(label: "More Cool Casts")
                            MoreCastsView()
                            
                        }
                    }
                    .navigationBarTitle("Browse")
                    .navigationBarHidden(true)
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                    //                        .padding(.top, 16.0)
                    Text("Browse")
                }                
                
            } else {
                NavigationView {
                    VStack {
                        SearchBar(text: $searchText, onTextChanged: loadPodcasts(search:))
                            .padding([.leading,.trailing])
                        List(networkManager.podcasts, id: \.self) { podcast in
                            
                            NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.origins)) {
                                
                                RemoteImage(url: podcast.artworkUrl600 ?? "")
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(podcast.trackName ?? "not loading")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(podcast.artistName ?? "not loading")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("\(self.intToString(podcast.trackCount ?? 0)) episodes")
                                        .font(.caption)
                                        .fontWeight(.light)
                                }
                            }
                            .padding(.trailing)
                            
                        }
                        .listStyle(GroupedListStyle())
                        .environment(\.horizontalSizeClass, .regular)
                    }
                    .navigationBarTitle("Browse")
                    .navigationBarHidden(true)
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .padding(.top, 16.0)
                    Text("Browse")
                }
            }
        }
    }
    
    
    func loadPodcasts(search: String) {
        networkManager.updatePodcasts(forSearch: searchText)
    }
    
    func intToString(_ int: Int) -> String {
        return String(int)
    }
}

struct TabTwo: View {
    var body: some View {
        EpisodeDetailView(podcast: DummyPodcast.origins)
            .tabItem {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .padding(.top, 16.0)
                Text("Favorites")
        }
    }
}

struct TabThree: View {
    var body: some View {
        TranscribeView(podcast: DummyPodcast.podcasts[4])
            .tabItem {
                
                Image(systemName: "textbox")
                    .font(.largeTitle)
                    .padding(.top, 16.0)
                Text("Transcribe")
        }
    }
}


