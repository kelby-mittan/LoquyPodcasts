//
//  EpisodeDetailView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            PodcastPosterView(podcast: podcast)
            TitleView(podcast: podcast)
            PodcastInfoView()
            RatingsView()
            DescriptionView(podcast: podcast)
            GuestView(podcast: podcast)
            PurchaseView()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView(podcast: DummyPodcast.origins)
    }
}

struct TitleView: View {
    
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    
    var body: some View {
        HStack {
            Text(podcast.title)
                //                .font(.title)
                .fontWeight(.heavy)
                .padding(.leading)
            
            Spacer()
            
            Image(systemName: "bookmark")
                .font(.largeTitle)
                .padding(.top, 4)
                .foregroundColor(.yellow)
                .padding(.trailing)
        }
        .padding(.vertical)
    }
}

struct PodcastInfoView: View {
    var body: some View {
        HStack {
            Text("2h 30m | Physics, Philosophy | 19 July 2020")
                .foregroundColor(.secondary)
                .padding(.leading)
            Spacer()
        }
    }
}

struct RatingsView: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { item in
                Image(systemName: "star.fill")
            }
            Image(systemName: "star.lefthalf.fill")
            Image("star")
            
            Text("3.5")
                .bold()
                .padding(.leading)
            Spacer()
        }
        .padding(.leading)
        .foregroundColor(.yellow)
    }
}

struct DescriptionView: View {
    
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(podcast.description)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom)
            
            Text("")
            
        }
        .padding()
    }
}

struct GuestView: View {
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    var body: some View {
        VStack {
            HStack {
                Text("Guest")
                    .fontWeight(.medium)
                Spacer()
                Button(action: seeGuestInfoButton) {
                    Text("See Info")
                }
                .padding()
                .foregroundColor(.secondary)
                .clipShape(Capsule())
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(0 ..< 10) { item in
                        VStack {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 60))
                            Text(self.podcast.guest.replacingOccurrences(of: " ", with: "\n"))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.top, 2)
                            
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    func seeGuestInfoButton() {
        print("Guest Info")
    }
}

struct PurchaseView: View {
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            Text("Add to Favorites")
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 24)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
        }
    }
}
