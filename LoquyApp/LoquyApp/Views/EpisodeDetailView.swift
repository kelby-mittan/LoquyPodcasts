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
    
    @State var image = RemoteImage(url: "")
    
    @State var halfModalShown = false
    @State var clipTime = ""
    @State var times = [String]()
    @State var showNotification = false
    @State var showSavedNotification = false
    @State var notificationMessage = ""
    //    @Binding var modalShown: Bool
    
    let player = Player.shared.player
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {

                image
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)
                    .padding(.top,100)
                    .padding([.leading,.trailing])
                    .onTapGesture(perform: {
                        dump(try! Persistence.artWork.loadItems())
                })
                
                ControlView(episode: episode, player: player, networkManager: networkManager, showModal: $halfModalShown, clipTime: $clipTime)
                
                EpisodeTimesView(episode: episode, player: player, networkManager: networkManager)
                
                DescriptionView(episode: episode)
                
                FavoriteView(episode: episode, artwork: artwork, notificationShown: $showNotification, message: $notificationMessage)
                    .padding(.bottom, 100)
                
            }
            
            NotificationView(message: $notificationMessage)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0))
            
            HalfModalView(isShown: $halfModalShown, modalHeight: 500){
                ClipAlertView(clipTime: clipTime, episode: episode, networkManager: networkManager, modalShown: $halfModalShown, notificationShown: $showNotification, message: $notificationMessage)
            }
//                .background(Color(.secondarySystemBackground))
        }.onAppear(perform: {
            image = RemoteImage(url: episode.imageUrl ?? "")
            clipTime = player.currentTime().toDisplayString()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .edgesIgnoringSafeArea(.all)
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
    
    @Binding var message: String
    
    var body: some View {
        Text(message)
            .fontWeight(.bold)
            .padding()
            .font(.title)
            .foregroundColor(Color.white)
            .frame(width: UIScreen.main.bounds.width - 40, height: 40)
            .background(Color.purple)
            .cornerRadius(20)
        
    }
}



