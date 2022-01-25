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

@available(iOS 14.0, *)
struct EpisodeDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    let episode: Episode
    let artwork: String
    let feedUrl: String?
    let isDeepLink: Bool
    @State var domColor: UIColor?
    
    @State var remoteImage = RemoteImageDetail(url: RepText.empty)
    @State var halfModalShown = false
    @State var timeStampAlertShown = false
    @State var clipTime = RepText.empty
    @State var currentTime = RepText.empty
    @State var timestampTime = RepText.empty
    @State var times = [String]()
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
                    .padding([.leading,.trailing])
                    .animation(.easeInOut, value: playing)
                
                ControlView(episode: episode,
                            isPlaying: $playing,
                            showModal: $halfModalShown,
                            clipTime: $clipTime,
                            domColor: $domColor,
                            currentTime: $currentTime,
                            showAlert: $timeStampAlertShown,
                            timestampTime: $timestampTime)
                    .padding(.top, playing ? 0 : 25)
                    .environmentObject(viewModel)
                
                EpisodeTimesView(episode: episode, isPlaying: $playing, domColor: $domColor)
                    .padding([.leading,.trailing],8)
                    .environmentObject(viewModel)
                
                DescriptionView(episode: episode)
                    .padding([.leading,.trailing], 8)
                                
                FavoriteView(episode: episode, artwork: artwork, notificationShown: $showNotification, message: $notificationMessage, domColor: $domColor)
                    .padding(.bottom, 100)
                
            }
//            .blur(radius: (halfModalShown || timeStampAlertShown) ? 12 : 0)
            
            
            NotificationView(message: $notificationMessage, domColor: $domColor)
                .offset(y: showNotification ? -UIScreen.main.bounds.height/3 : -UIScreen.main.bounds.height)
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
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(RepText.empty, displayMode: .inline)
        .navigationBarItems(leading:
                                NavigationLink(
                                    destination: BrowseView(),
                                    label: {
                                        Text(isDeepLink ? RepText.goBrowse : RepText.empty)
                                    })
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
    @Binding var domColor: UIColor?
    
    var body: some View {
        Text(message)
            .fontWeight(.bold)
            .padding()
            .font(.title)
            .foregroundColor(Color.white)
            .frame(width: UIScreen.main.bounds.width - 40, height: 60)
            .background(Color(domColor ?? .lightGray))
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
