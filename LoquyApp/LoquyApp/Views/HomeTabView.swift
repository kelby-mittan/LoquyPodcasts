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
    
    //    init () {
    //        UITabBar.appearance().backgroundColor = UIColor.green
    //    }
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BrowseView().tag(1)
            TabTwo().tag(2)
            TabThree().tag(3)
            TabFour().tag(4)
        }
        .padding(.bottom, 0)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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

struct BrowseView: View {
    @State private var searchText = ""
    @State private var isPodcastShowing = true
    @State private var isEditing = false
    @ObservedObject private var networkManager = NetworkingManager()
    
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
                            NavigationLink(destination: EpisodesView(title: mindcast.title, podcastFeed: mindcast.feedUrl)) {
                                ListenToView()
                            }
                            PodcastScrollView()
                            
                            FeaturedView()
                            
                            HeaderView(label: "More Cool Casts")
                            MoreCastsView()
                        }
                        
                    } else {
                        List(networkManager.podcasts, id: \.self) { podcast in
                            
                            NavigationLink(destination: EpisodesView(title: podcast.trackName ?? "", podcastFeed: podcast.feedUrl ?? "")) {
                                
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
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
            Text("Browse")
        }
    }
    
    
    func loadPodcasts(search: String) {
        networkManager.updatePodcasts(forSearch: searchText)
        print(isEditing)
    }
}

struct TabTwo: View {
    var body: some View {
        LoquyListView()
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

struct TabFour: View {
    var body: some View {
        AudioClipsView()
            .tabItem {
                
                Image(systemName: "list.bullet")
                    .font(.largeTitle)
                    .padding(.top, 16.0)
                Text("Loquies")
        }
    }
}


