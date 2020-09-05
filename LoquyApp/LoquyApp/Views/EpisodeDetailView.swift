//
//  EpisodeDetailView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Alamofire
import AVKit
import MediaPlayer

struct EpisodeDetailView: View {
    
    let episode: Episode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            RemoteImage(url: episode.imageUrl ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding()
            
            ControlView(episode: episode)
            DescriptionView(episode: episode)
            FavoriteView(episode: episode)
        }
        .navigationBarTitle("", displayMode: .inline)
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
    
    let episode: Episode
    
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text("Save Episode")
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
                .onTapGesture {
                
                    var episodes = UserDefaults.standard.savedEpisodes()
                    episodes.append(self.episode)
                    print(self.episode.author)
                    
                    UserDefaults.standard.saveTheEpisode(episode: self.episode)
                    
                    print("Tapped favorites")
            }
        }
        
    }
}

