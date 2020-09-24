//
//  EpisodeTimesView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/7/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit

struct EpisodeTimesView: View {
    
    let episode: Episode
    let player: AVPlayer
    
    @State var timeStamps = [String]()
    
    @ObservedObject var networkManager: NetworkingManager
    
    var body: some View {
        Group {
            if UserDefaults.standard.savedEpisodes().contains(episode) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(networkManager.timeStamps.sorted(), id:\.self) { time in
                            ZStack {
                                Text(time)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 2)
                                
                            }.onTapGesture {
                                player.seek(to: time.getCMTime())
                                player.play()
                            }
                            .onLongPressGesture {
                                guard let tStamp = UserDefaults.standard.savedTimeStamps().filter({ $0.time == time && $0.episode == episode }).first else {
                                    return
                                }
                                
                                UserDefaults.standard.deleteTimeStamp(timeStamp: tStamp)
                                loadTimes(episode: episode)
                                dump(tStamp)
                            }
                            .frame(width: 84, height: 40)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                        }
                    }.padding([.leading,.trailing])
                }.onAppear {
                    loadTimes(episode: episode)
                }
            }
        }
    }
    
//    @discardableResult
//    func getTimes() -> [String] {
//        return UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
//    }
    
    func loadTimes(episode: Episode) {
        networkManager.loadTimeStamps(for: episode)
    }
}
