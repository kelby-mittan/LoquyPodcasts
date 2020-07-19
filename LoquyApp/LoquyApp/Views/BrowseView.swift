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
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top)
                List(DummyPodcast.podcasts.filter({ searchText.isEmpty ? true : $0.title.contains(searchText)})) { podcast in
                    
                    NavigationLink(destination: EpisodeDetailView(podcast: podcast)) {
                        PodcastPosterView(podcast: podcast)
                        Text(podcast.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing)
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
