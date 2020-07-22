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
            TabOne1().tag(1)
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

//struct TabOne: View {
//    @State private var searchText = ""
//    @ObservedObject private var viewModel = PodcastListViewModel()
//    @State private var poddcasts = [Podcast]()
////    var podcasts = ITunesAPI.shared.getPodcasts(searchText: "joerogan") { (podcasts) in
////
////        dump(podcasts)
////    }
//
//    var body: some View {
//
////        loaded = fetchPodcasts(search: searchText)
//
//        NavigationView {
//            VStack {
//                SearchBar(text: $searchText)
//                    .padding(.top)
//
//                List {
//                    ForEach(viewModel.podcasts, id: \.self) { podcast in
//                        NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.origins)) {
//                            PodcastPosterView(podcast: DummyPodcast.origins, width: 100, height: 100)
//                            Text(podcast.artistName ?? "not loading")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                        }
//                        .padding(.trailing)
//                    }
//                }
//                .onAppear {
//                    self.viewModel.getThePodcasts(search: self.searchText)
//                    dump(self.fetchPodcasts(search: self.searchText))
//                }
//                .navigationBarTitle("Podcasts")
//            }
//            .navigationBarTitle("Podcasts", displayMode: .automatic)
//        }
//        .tabItem {
//            Image(systemName: "list.dash")
//                .font(.largeTitle)
//                .padding(.top, 16.0)
//            Text("Menu")
//        }
//    }
//
//    func fetchPodcasts(search: String) -> [Podcast] {
//        var results = [Podcast]()
//        ITunesAPI.shared.getPodcasts(searchText: search) { (podcasts) in
//            dump(podcasts)
//            results = podcasts
//        }
//        return results
//    }
//}

struct TabOne1: View {
    @State private var searchText = ""
    @ObservedObject private var viewModel = PodcastViewModel()
    @State private var isPodcastShowing = true
    
    var body: some View {
        
        Group {
            if searchText.isEmpty {
                NavigationView {
                    VStack {
                        
                        SearchBar(text: $searchText, onTextChanged: loadPodcasts(search:))
                            .padding([.leading,.trailing])
                        
                        ScrollView(.vertical) {
                            
                            HeaderView(label: "Listen To")
                            
                            NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.podcasts[4])) {
                                PodcastContentView(isPodcastShowing: $isPodcastShowing)
                            }
                            
                            PodcastScrollView()
                            
                            
                        }
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
                
                
            } else {
                NavigationView {
                    VStack {
                        SearchBar(text: $searchText, onTextChanged: loadPodcasts(search:))
                            .padding([.leading,.trailing])
                        
                        List(viewModel.pcasts) { podcast in
                            NavigationLink(destination: EpisodeDetailView(podcast: DummyPodcast.origins)) {
                                
                                PodcastPosterView(podcast: DummyPodcast.origins, width: 100, height: 100)
                                
                                Text(podcast.artistName ?? "not loading")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.trailing)
                            
                        }
                            //                        .background(Color.black)
                            .listStyle(GroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                        //                        .navigationBarTitle("Podcasts")
                    }
                        //                    .navigationBarTitle("Podcasts", displayMode: .automatic)
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
        ITunesAPI.shared.loadPodcasts(searchText: search) { (podcasts) in
            dump(podcasts)
            self.viewModel.pcasts = podcasts
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

struct PodcastContentView: View {
    
    @Binding var isPodcastShowing: Bool
    
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                Image("mindscape")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 150, height: 150, alignment: .center)
                    .cornerRadius(8)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 160, y: 0)
                    .background(Color.clear)
                
                VStack(alignment: .leading) {
                    PCastHeaderLabelView(label: "Mindscape")
                    //                    PCastHeaderLabelView(label: "Sean Carroll")
                    PCastBodyLabelView(label: "Sean Carroll")
                }
                
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemIndigo), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(14)
        
    }
}

struct PCastHeaderLabelView: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(Color.white)
    }
}

struct PCastBodyLabelView: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .foregroundColor(Color(.systemGray5))
    }
}

struct HeaderView: View {
    
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.title)
                .fontWeight(.heavy)
            Spacer()
        }
        .padding(.leading)
    }
}

struct PodcastScrollView: View {
    
    var pCasts = DummyPodcast.podcasts
    
    var body: some View {
        VStack {
            HeaderView(label: "Top Podcasts")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< 5) { item in
                        PodcastView()
                    }
                }
            }
        }
    }
}

struct PodcastView: View {
    
    var pCasts = DummyPodcast.podcasts[0...1]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(pCasts, id: \.id) { pcast in
                NavigationLink(destination: Text("Coming Soon")) {
                    
                    HStack(alignment: .top) {
                        Image(pcast.image)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 72, height: 72)
                            .background(Color.purple)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(pcast.title)
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding(.bottom, 4)
                            Text(pcast.host)
                                .foregroundColor(Color(.label))
                                .font(.subheadline)
                                .fontWeight(.light)
                                .padding(.bottom, 4)
                            
                            
                            HStack {
                                Text(pcast.category)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .padding(.bottom, 4)
                                Spacer()
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: 100, height: 8)
                                        .foregroundColor(Color(.systemGray4))
                                    
                                    Rectangle()
                                        .frame(width: 40, height: 8)
                                        .foregroundColor(Color(.orange))
                                }
                                .clipShape(Capsule())
                            }
                            
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
}
