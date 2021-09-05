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
    @Binding var isPlaying: Bool
    @Binding var domColor: UIColor?
    
    let player = Player.shared.player
    @EnvironmentObject var viewModel: ViewModel
    @State var timeStamps = [String]()
    
    var body: some View {
        Group {
            if Persistence.episodes.hasItemBeenSaved(episode) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.timeStamps.sorted(), id:\.self) { time in
                            ZStack {
                                Text(time)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 2)
                                
                            }
                            .onTapGesture {
                                player.seek(to: time.getCMTime())
                                player.play()
                                isPlaying = true
                            }
                            .onLongPressGesture {
                                deleteTimeStamp(time)
                            }
                            .frame(width: 84, height: 40)
                            .background(Color(domColor ?? .lightGray))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    loadTimes(episode: episode)
                }
            }
        }
    }
    
    private func deleteTimeStamp(_ time: String) {
        do {
            let tStamps = try Persistence.timeStamps.loadItems().filter({ $0.episode == episode })
                                                
            let index = tStamps.firstIndex { (timeStamp) -> Bool in
                timeStamp.time == time
            }
            
            guard let i = index else {
                return
            }
            
            try Persistence.timeStamps.deleteItem(at: i)
            
        } catch {
            print(error.localizedDescription)
        }
        loadTimes(episode: episode)
    }
    
    private func loadTimes(episode: Episode) {
        viewModel.loadTimeStamps(for: episode)
    }
    
}
