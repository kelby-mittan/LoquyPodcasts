//
//  CardPageView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CardPageView: View {
    
    @Binding var page: Int
    
    let imageUrl: String
    
    @ObservedObject var networkManager: ViewModel
    
    @State private var transcription: String = RepText.empty
    @State private var shareShown = false
    
    var data: Loquy
    
    let podImage = UIImage(named: Assets.loquyImage)!
    
    @State var attString = NSMutableAttributedString()
    
    var body: some View {
        Group {
                        
            let loquy = networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.reversed()[page]
            
            ZStack {
                
                CardNeoView(isRan: true)
                    .padding([.leading,.trailing])
                    .cornerRadius(20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Text(loquy.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding([.leading,.trailing,.top,.bottom])
                    
                    NavigationLink(destination: EpisodeDetailView(episode: loquy.audioClip.episode, artwork: loquy.audioClip.episode.imageUrl ?? RepText.empty, feedUrl: loquy.audioClip.feedUrl, isDeepLink: false)) {
                        
                        Text(loquy.audioClip.episode.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .font(.headline)
                            .underline()
                            .padding([.leading,.trailing])
                    }.padding([.leading,.trailing])
                    
                    HStack {
                        RemoteImage(url: loquy.audioClip.episode.imageUrl ?? "")
                            .frame(width: 100, height: 100)
                            .cornerRadius(6)
                            .padding([.trailing,.leading])
                        
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
                            
                        }.padding([.leading,.trailing,.top])
                        
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
                            .padding([.top,.leading,.trailing]).padding(.bottom,72)
                    }
                    .padding([.trailing,.leading], 20)
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
                                NeoButtonView()
                                Image(systemName: Symbol.share).font(.title)
                                    .foregroundColor(.purple)
                            }.background(NeoButtonView())
                            .frame(width: 50, height: 50)
                            .clipShape(Capsule())
                            
                        }
                        .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                        .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                        .offset(x: -20)
                        .sheet(isPresented: $shareShown) {
                            let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
                            
                            let appURL = URL(string: appPath)!
                            
                            ShareView(items: [loquy.title,"\n","\n",loquy.transcription,"\n","\n",appURL,podImage])
                            
//                            let appStoreURL = URL(string: "https://apps.apple.com/us/app/loquy/id1532251878")!
                            
                        }
                        
                    }
                }.padding([.leading,.trailing,.bottom])
                
                
            }
            .onAppear {
                networkManager.loadLoquys()
                
                let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
                
                let appURL = URL(string: appPath)!
                
                print(appURL.absoluteString)
                
                attString = NSMutableAttributedString(string: "Check it out")
                attString.setAttributes([.link: appURL], range: NSMakeRange(attString.length-12, 12))
                
            }
            .cornerRadius(12)
            .padding(.top)
        }
    }
    
    func getLoquys() {
        networkManager.loadLoquys()
    }
}
