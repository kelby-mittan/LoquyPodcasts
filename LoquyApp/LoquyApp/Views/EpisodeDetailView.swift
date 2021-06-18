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

@available(iOS 14.0, *)
struct EpisodeDetailView: View {
    
    let episode: Episode
    let artwork: String
    let feedUrl: String?
    let isDeepLink: Bool
    
    @ObservedObject private var networkManager = ViewModel()
    
    @State var image = RemoteImageDetail(url: "")
    
    @State var halfModalShown = false
    @State var clipTime = ""
    @State var times = [String]()
    @State var showNotification = false
    @State var notificationMessage = ""
    @State var playing = true
    
    let player = Player.shared.player
    
    var body: some View {
        Group {
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    
                    image
                        .aspectRatio(contentMode: .fit)
                        .frame(width: playing ? 250 : 200, height: playing ? 250 : 200)
                        .cornerRadius(12)
                        .padding(.top, playing ? 100 : 125)
                        .padding([.leading,.trailing])
                        .animation(.easeInOut)
                    
                    ControlView(episode: episode, isPlaying: $playing, player: player, networkManager: networkManager, showModal: $halfModalShown, clipTime: $clipTime)
                        .padding(.top, playing ? 0 : 25)
                    
                    EpisodeTimesView(episode: episode, player: player, networkManager: networkManager)
                    
                    DescriptionView(episode: episode)
                    
                    FavoriteView(episode: episode, artwork: artwork, notificationShown: $showNotification, message: $notificationMessage)
                        .padding(.bottom, 100)
                    
                }
                
                NotificationView(message: $notificationMessage)
                    .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0))
                
                if halfModalShown {
                    HalfModalView(isShown: $halfModalShown, modalHeight: 500){
                        ClipAlertView(clipTime: clipTime, episode: episode, feedUrl: feedUrl, networkManager: networkManager, modalShown: $halfModalShown, notificationShown: $showNotification, message: $notificationMessage)
                    }
                }
                
            }.onAppear {
                image = RemoteImageDetail(url: episode.imageUrl ?? "")
                clipTime = player.currentTime().toDisplayString()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    NavigationLink(
                                        destination: BrowseView(),
                                        label: {
                                            Text(isDeepLink ? "Go Browse" : "")
                                        })
            )
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .font(.body)
                Text("Browse")
            }
        }
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



