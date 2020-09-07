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
    
    var body: some View {
        Group {
            if UserDefaults.standard.savedEpisodes().contains(episode) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(getTimes().sorted(), id:\.self) { time in
                            ZStack {
                                Text(time)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 2)
                                
                            }.onTapGesture {
//                                print(time)
                                self.player.seek(to: time.getCMTime())
                            }
                            .onLongPressGesture {
                                guard let tStamp = UserDefaults.standard.savedTimeStamps().filter({ $0.time == time && $0.episode == self.episode }).first else {
                                    return
                                }
                                
                                UserDefaults.standard.deleteTimeStamp(timeStamp: tStamp)
                                dump(tStamp)
                            }
                            .frame(width: 84, height: 40)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                        }
                    }.padding([.leading,.trailing])
                }
            }
        }
    }
    
    func getTimes() -> [String] {
        //        networkManager.timeStamps = UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
        //        networkManager.loadTimeStamps(for: episode)
        return UserDefaults.standard.savedTimeStamps().filter { $0.episode == episode }.map { $0.time }
    }
}
