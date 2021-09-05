//
//  CardScrollView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/20/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CardScrollView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    let loquy: Loquy
    @Binding var shareShown: Bool
    @State var domColor: UIColor?
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                Text(loquy.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding([.vertical,.horizontal])
                
                NavigationLink(destination: EpisodeDetailView(episode: loquy.audioClip.episode,
                                                              artwork: loquy.audioClip.episode.imageUrl ?? RepText.empty,
                                                              feedUrl: loquy.audioClip.feedUrl,
                                                              isDeepLink: false,
                                                              domColor: domColor ?? .lightGray)
                                
                                .environmentObject(viewModel)
                ) {
                    
                    Text(loquy.audioClip.episode.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .underline()
                        .padding(.horizontal)
                }
                .padding([.leading,.trailing])
                
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
                .padding([.leading,.trailing,.bottom,.top])
                
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
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        shareShown = true
                    }) {
                        ZStack {
                            NeoButtonView(domColor: $domColor)
                            Image(systemName: Symbol.share)
                                .font(.title)
                                .foregroundColor(Color(domColor ?? .white))
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Capsule())
                    }
                    .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                    .offset(x: -20)
                }
            }
            .padding([.horizontal,.bottom])
        }
        .onAppear {
            domColor = UIColor.color(withCodedString: loquy.audioClip.domColor ?? RepText.empty)
        }
        .background(
            Color(UIColor.color(withCodedString: loquy.audioClip.domColor ?? RepText.empty) ?? .clear)
        )
    }
}
