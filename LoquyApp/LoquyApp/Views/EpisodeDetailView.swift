//
//  EpisodeDetailView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Alamofire

struct EpisodeDetailView: View {
    
    let podcast: DummyPodcast
    
    init(podcast: DummyPodcast) {
        self.podcast = podcast
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            PodcastPosterView(podcast: podcast, width: 250, height: 250)
            ControlView()
            DescriptionView(podcast: podcast)
            GuestView(podcast: podcast)
            NavigationLink(destination: Text("Add to Favorites")) {
                
                Text("Add to Favorites")
                    .fontWeight(.heavy)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 44)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .clipShape(Capsule())
                    .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView(podcast: DummyPodcast.origins)
    }
}

struct ControlView: View {
    
    @State var width : CGFloat = 30
    @State var playing = true
    @State var paused = false
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                            let x = value.location.x
                            
                            self.width = x
                            
                        }).onEnded({ (value) in
//
//                            let x = value.location.x
//
//                            let screen = UIScreen.main.bounds.width - 30
//
//                            let percent = x / screen
                            
                        }))
            }
            .padding(.top)
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 30) {
                
                Button(action: {
                    
                }) {
                    Image(systemName: "gobackward.15").font(.title)
                }
                
                Button(action: {
                    self.paused.toggle()
                    self.playing.toggle()
                }) {
                    Image(systemName: self.playing && !self.paused ? "pause.fill" : "play.fill").font(.title)
                }
                
                Button(action: {
                    
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.title)
                    
                }
                
            }
            .padding(.top,25)
            //        .foregroundColor(.white)
        }
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
                Text(podcast.title)
                    //                .font(.title)
                    .fontWeight(.heavy)
//                    .padding(.leading)
                Spacer()
                
                Image(systemName: "star")
                    .font(.largeTitle)
                    .padding(.top, 4)
                    .foregroundColor(.yellow)
//                    .padding(.trailing)
            }
//            .padding(.vertical)
            
            Text("2h 30m | Physics, Philosophy | 19 July 2020")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
                Spacer()
            
            HStack {
                ForEach(0..<3) { item in
                    Image(systemName: "star.fill")
                }
                Image(systemName: "star.lefthalf.fill")
                Image(systemName: "star")
                
                Text("3.5")
                    .bold()
//                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 4)
            .foregroundColor(.yellow)
            
            HStack {
                Text(podcast.description)
                    .fontWeight(.bold)
                Spacer()
            }
//            .padding(.bottom)
            .padding(.top)
            
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
        ITunesAPI.shared.fetchPodcasts(searchText: "joe+rogan") { (podcasts) in
            dump(podcasts)
        }
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


