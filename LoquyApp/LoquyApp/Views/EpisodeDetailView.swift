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
    
    let episode: Episode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            RemoteImage(url: episode.imageUrl ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding()
                
            ControlView()
            DescriptionView(episode: episode)
            FavoriteView()
        }
        .navigationBarTitle("", displayMode: .inline)
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
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                            let x = value.location.x
                            let maxVal = UIScreen.main.bounds.width - 10
                            let minVal: CGFloat = 10
                            
                            if x < minVal {
                                self.width = minVal
                            } else if x > maxVal {
                                self.width = maxVal
                            } else {
                               self.width = x
                            }
                            
                            print("width val is : \(self.width)")
                            
                            
                        }).onEnded({ (value) in
//
//                            let x = value.location.x
//
//                            let screen = UIScreen.main.bounds.width - 30
//
//                            let percent = x / screen
                            
                        }))
                    .padding([.top,.leading,.trailing])
            }
            
            HStack {
                Text("0:00:00")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("2:30:00")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding([.leading,.trailing])
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
                
                Button(action: {
                    
                }) {
                    Image(systemName: "gobackward.15").font(.largeTitle)
                }
                
                Button(action: {
                    self.paused.toggle()
                    self.playing.toggle()
                }) {
                    Image(systemName: self.playing && !self.paused ? "pause.fill" : "play.fill").font(.largeTitle)
                }
                
                Button(action: {
                    
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            .padding(.top,25)
        }
    }
}

struct DescriptionView: View {
    
    let episode: Episode
    
    var body: some View {
        VStack {
            
            HStack {
                Text(episode.title)
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.top)
                Spacer()
            }
            
            HStack {
                Text("Philosophy | Physics | Science")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                Spacer()
            }
            
            HStack {
                Text(getOnlyDescription(episode.description))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top)
            
            
        }
        .padding()
    }
    
    func getOnlyDescription(_ str: String) -> String {
        var word = str
                
        if let index = word.range(of: "\n\n")?.lowerBound {
            let substring = word[..<index]

            word = String(substring)
        }
        if let index2 = word.range(of: "<a ")?.lowerBound {
            let substring = word[..<index2]
            word = String(substring)
        }
        
        word = word.replacingOccurrences(of: "</p>", with: "\n\n")
        word = word.replacingOccurrences(of: "<p>", with: "")
        word = word.replacingOccurrences(of: "&nbsp", with: "")
        word = word.replacingOccurrences(of: "  ", with: "")
        
        return word
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

struct FavoriteView: View {
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text("Add to Favorites")
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
        }
        
    }
}


