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
    
    @State var halfModalShown = false
    @State var clipTime = ""
    @State var times = [String]()
    
//    @Environment(\.presentationMode) var presentationMode
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                Spacer()
                RemoteImage(url: episode.imageUrl ?? "")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)
                    .padding([.leading,.trailing,.top])
                
                ControlView(episode: episode, player: player, networkManager: networkManager, showModal: $halfModalShown, clipTime: $clipTime)
                
                EpisodeTimesView(episode: episode, player: player, networkManager: networkManager)
                
                
                DescriptionView(episode: episode)//.offset(x: 0, y: -20)
                FavoriteView(episode: episode, artwork: artwork)
                
                
            }.offset(x: 0, y: 40)
            
            HalfModalView(isShown: $halfModalShown, modalHeight: 600){
                ClipAlertView(clipTime: self.clipTime)
            }
            
        }
        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarItems(leading: Button(""){self.presentationMode.wrappedValue.dismiss()})
    }
    
    func getCapsulePosition() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
}





