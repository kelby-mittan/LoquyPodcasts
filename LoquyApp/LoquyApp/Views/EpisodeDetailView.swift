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
    let artwork: String
    //    let isLocalImage: Bool
    
    @ObservedObject private var networkManager = NetworkingManager()
    
    @State var showAlert = false
    @State var text = "0:00:63"
    @State var times = [String]()
    
    var body: some View {
        //        ZStack {
        ScrollView(.vertical, showsIndicators: true) {
            RemoteImage(url: episode.imageUrl ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding()
                .onTapGesture {
                    //                        self.showAlert.toggle()
                    //                        print(self.$showAlert)
                    //                        dump(UserDefaults.standard.savedTimeStamps().filter { $0.episode == self.episode }.map { $0.time })
                    
//                dump(self.networkManager.timeStamps)
            }
            
            ControlView(episode: episode)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(getTimes(), id:\.self) { item in
                        VStack {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 60))
                            Text(item)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.top, 2)
                            
                        }
                        .padding()
                    }
                }
            }
            
            DescriptionView(episode: episode)//.offset(x: 0, y: -20)
            FavoriteView(episode: episode, artwork: artwork)
            
            
        }.onAppear(perform: {
            self.showAlert = self.networkManager.isShowAlert
            //            self.loadTimeStamps(episode: self.episode)
            //            self.getTimes(for: self.episode)
        })
            
            .navigationBarTitle("", displayMode: .inline)
    }
    
    //    func loadTimeStamps(episode: Episode) {
    //        networkManager.loadTimeStamps(for: episode)
    //    }
    
    func getTimes() -> [String] {
//        networkManager.timeStamps = UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
//        networkManager.loadTimeStamps(for: episode)
        return UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
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
        .padding([.leading,.trailing,.bottom])
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
    let artwork: String
    @State var isSaved = false
    @State var saveText = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationLink(destination: Text("Add to Favorites")) {
            
            Text(saveText)
                .fontWeight(.heavy)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 88)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding()
                .onTapGesture {
                    
                    
                    if !self.isSaved {
                        var episodes = UserDefaults.standard.savedEpisodes()
                        episodes.append(self.episode)
                        self.saveText = "Remove Episode"
                        UserDefaults.standard.saveTheEpisode(episode: self.episode)
                        
                        var pCasts = UserDefaults.standard.getPodcastArt()
                        pCasts.append(self.artwork)
                        UserDefaults.standard.setPodcastArt(pCasts)
                        
                    } else {
                        self.saveText = "Save Episode"
                        UserDefaults.standard.deleteEpisode(episode: self.episode)
                        UserDefaults.standard.deletePodcastArt(self.artwork)
                    }
                    self.isSaved.toggle()
            }
        }.onAppear {
            if UserDefaults.standard.savedEpisodes().contains(self.episode) {
                self.isSaved = true
                self.saveText = "Remove Episode"
            } else {
                self.isSaved = false
                self.saveText = "Save Episode"
            }
            
        }
        
    }
}

