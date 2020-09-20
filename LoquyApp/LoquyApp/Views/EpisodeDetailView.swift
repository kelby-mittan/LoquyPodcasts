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
    @State var showNotification = true
    //    @Binding var modalShown: Bool
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                RemoteImage(url: episode.imageUrl ?? "")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)
                    .padding([.leading,.trailing])
                
                ControlView(episode: episode, player: player, networkManager: networkManager, showModal: $halfModalShown, clipTime: $clipTime)
                
                EpisodeTimesView(episode: episode, player: player, networkManager: networkManager)
                
                DescriptionView(episode: episode)//.offset(x: 0, y: -20)
                FavoriteView(episode: episode, artwork: artwork)
                
            }.padding([.top,.bottom], 100)
            
            NotificationView()
                .offset(y: self.showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
            
            HalfModalView(isShown: $halfModalShown, modalHeight: 600){
                ClipAlertView(clipTime: self.clipTime, modalShown: $halfModalShown)
            }
        }.onAppear(perform: {
            clipTime = player.currentTime().toDisplayString()
        })
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func getCapsulePosition() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
}

struct NotificationView: View {
    
    var body: some View {
        Text("clip saved")
            .fontWeight(.bold)
            .padding()
            .font(.title)
            .foregroundColor(Color.white)
            .frame(width: UIScreen.main.bounds.width - 40, height: 40)
            .background(Color.purple)
            .cornerRadius(20)
        
    }
}



