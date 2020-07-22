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
                            
                            HeaderView(label: "Check Out")
                            
                            PodcastContentView(isPodcastShowing: $isPodcastShowing)
                            
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
                    .frame(width: 150, height: 150, alignment: .center)
                    .cornerRadius(8)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 160, y: 0)
                
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
        Text(label)
    }
}
