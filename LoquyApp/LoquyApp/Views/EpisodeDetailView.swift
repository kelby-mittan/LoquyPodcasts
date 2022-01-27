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
import WebKit

struct EpisodeDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    // MARK: injected properties
    
    let episode: Episode
    let artwork: String
    let feedUrl: String?
    let isDeepLink: Bool
    @State var dominantColor: UIColor?
    var audioClip: AudioClip?
    
    @State var remoteImage = RemoteImageDetail(url: RepText.empty)
    @State var halfModalShown = false
    @State var timeStampAlertShown = false
    @State var clipTime = RepText.empty
    @State var currentTime = RepText.empty
    @State var timestampTime = RepText.empty
    @State var showNotification = false
    @State var notificationMessage = RepText.empty
    @State var playing = true
    
    let player = Player.shared.player
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                remoteImage
                    .aspectRatio(contentMode: .fit)
                    .frame(width: playing ? 250 : 200, height: playing ? 250 : 200)
                    .cornerRadius(12)
                    .padding(.top, playing ? 100 : 125)
                    .padding(.horizontal)
                    .animation(.easeInOut, value: playing)
                
                ControlView(episode: episode,
                            isPlaying: $playing,
                            showModal: $halfModalShown,
                            clipTime: $clipTime,
                            dominantColor: $dominantColor,
                            currentTime: $currentTime,
                            showAlert: $timeStampAlertShown,
                            timestampTime: $timestampTime,
                            audioClip: audioClip)
                    .padding(.top, playing ? 0 : 25)
                    .environmentObject(viewModel)
                
                
                if !viewModel.timeStamps.isEmpty {
                    EpisodeTimesView(episode: episode, isPlaying: $playing, dominantColor: $dominantColor)
                        .padding(.horizontal,8)
                        .environmentObject(viewModel)
                }
                
                DescriptionView(episode: episode)
                    .padding(.horizontal, 8)
                
            }
            
            
            NotificationView(message: $notificationMessage, dominantColor: $dominantColor)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3.33 : -UIScreen.main.bounds.height)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 12, initialVelocity: 0), value: showNotification)
            
            
            if halfModalShown {
                HalfModalView(isShown: $halfModalShown, modalHeight: 500){
                    ClipAlertView(clipTime: clipTime,
                                  episode: episode,
                                  feedUrl: feedUrl,
                                  modalShown: $halfModalShown,
                                  notificationShown: $showNotification,
                                  message: $notificationMessage)
                        .environmentObject(viewModel)
                }
                .animation(.default, value: halfModalShown)
            }
            
            if timeStampAlertShown {
                TimeStampAlertView(showAlert: $timeStampAlertShown, time: timestampTime, episode: episode)
                    .offset(y: 80)
                    .edgesIgnoringSafeArea(.all)
                    .environmentObject(viewModel)
            }
            
        }
        
        .onAppear {
            remoteImage = RemoteImageDetail(url: episode.imageUrl ?? RepText.empty)
            clipTime = player.currentTime().toDisplayString()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle(RepText.empty, displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {}) {
                                    FavoriteView(episode: episode,
                                                 artwork: artwork,
                                                 notificationShown: $showNotification,
                                                 message: $notificationMessage,
                                                 dominantColor: $dominantColor,
                                                 timestampAlertShown: $timeStampAlertShown)
                                }
        )
        .tabItem {
            Image(systemName: Symbol.magGlass)
                .font(.body)
            Text(HomeText.browse)
        }
    }
    
}

struct NotificationView: View {
    
    @Binding var message: String
    @Binding var dominantColor: UIColor?
    
    var body: some View {
        Text(message)
            .fontWeight(.bold)
            .padding()
            .font(.title)
            .foregroundColor(Color.white)
            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
            .background(Color(dominantColor ?? .lightGray))
            .cornerRadius(20)
        
    }
}


//
//struct WebViewRepresentation: UIViewRepresentable {
//
//    let webAddress: String
//
//    func makeUIView(context: Context) -> WKWebView {
//
//
//        guard let webURL = URL(string: webAddress) else {
//            return WKWebView()
//        }
//
//        let request = URLRequest(url: webURL)
//
//
//        let uiView = WKWebView()
//
////        uiView.loadHTMLString(webAddress, baseURL: .none)
//
//        uiView.load(request)
//
//
//        return uiView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) { }
//
//}
//
//
//struct WebView: View {
//
//    let webAddress: String
//
//    var body: some View {
//        VStack {
//            WebViewRepresentation(webAddress: webAddress)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
