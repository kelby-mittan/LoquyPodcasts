//
//  BrowseView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

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
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    var body: some View {
        Image(podcast.image)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200.0, height: 200.0)
            .cornerRadius(12)
            .padding()
    }
}

struct TabOne: View {
    @State private var searchText = ""
    @ObservedObject private var viewModel = PodcastListViewModel()
    @State private var poddcasts = [Podcast]()
//    var podcasts = ITunesAPI.shared.getPodcasts(searchText: "joerogan") { (podcasts) in
//
//        dump(podcasts)
//    }
    
    var body: some View {
        
//        loaded = fetchPodcasts(search: searchText)
        
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top)
                
                List(viewModel.podcasts) { podcast in
                    
                    NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.origins)) {
                        PodcastPosterView(podcast: DummyPodcast.origins)
                        Text(podcast.artistName ?? "not loading")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing)
                }
                .onAppear {
                    self.viewModel.getThePodcasts(search: self.searchText)
                }
                .navigationBarTitle("Podcasts")
            }
            .navigationBarTitle("Podcasts", displayMode: .automatic)
        }
        .tabItem {
            Image(systemName: "list.dash")
                .font(.largeTitle)
                .padding(.top, 16.0)
            Text("Menu")
        }
    }
    
    func fetchPodcasts(search: String) -> [Podcast] {
        var results = [Podcast]()
        ITunesAPI.shared.getPodcasts(searchText: search) { (podcasts) in
            dump(podcasts)
            results = podcasts
        }
        return results
    }
}

struct TabTwo: View {
    var body: some View {
        EpisodeDetailView(podcast: DummyPodcast.origins)
            .tabItem {
                
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .padding(.top, 16.0)
                Text("Detail")
        }
    }
}

struct TabThree: View {
    var body: some View {
        EpisodeDetailView(podcast: DummyPodcast.origins)
            .tabItem {
                
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .padding(.top, 16.0)
                Text("Detail")
        }
    }
}
