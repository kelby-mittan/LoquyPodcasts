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
    
    @ObservedObject private var networkManager = NetworkingManager()
    
    @State var showAlert = false
    @State var text = "0:08:22"
    @State var times = [String]()
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            RemoteImage(url: episode.imageUrl ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding([.leading,.trailing,.top])
            
            ControlView(episode: episode, player: player, networkManager: networkManager)
            
            EpisodeTimesView(episode: episode, player: player, networkManager: networkManager)
            
            
            DescriptionView(episode: episode)//.offset(x: 0, y: -20)
            FavoriteView(episode: episode, artwork: artwork)
            
            
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func getCapsulePosition() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
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
        
    }
}





