//
//  CardScrollView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/20/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct CardScrollView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    let loquy: Loquy
    @Binding var shareShown: Bool
    @State var dominantColor: UIColor?
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                Text(loquy.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding()
                
                NavigationLink(destination: EpisodeDetailView(episode: loquy.audioClip.episode,
                                                              artwork: loquy.audioClip.episode.imageUrl ?? RepText.empty,
                                                              feedUrl: loquy.audioClip.feedUrl,
                                                              isDeepLink: false,
                                                              dominantColor: dominantColor ?? .lightGray)
                                
                                .environmentObject(viewModel)
                ) {
                    
                    Text(loquy.audioClip.episode.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .underline()
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                HStack {
                    RemoteImage(url: loquy.audioClip.episode.imageUrl ?? RepText.empty)
                        .frame(width: 100, height: 100)
                        .cornerRadius(6)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("clip: \(loquy.audioClip.title)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("\(loquy.audioClip.startTime) - \(loquy.audioClip.endTime)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                        
                    }
                    
                }
                .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(LoquynClipText.loquyTranscript)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .padding(.leading)
                        
                        Text("\(loquy.transcription)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .padding([.top,.horizontal])
                            .padding(.bottom,72)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            dominantColor = UIColor.color(withCodedString: loquy.audioClip.dominantColor ?? RepText.empty)
        }
        .background(
            Color(dominantColor ?? .clear)
        )
    }
}
