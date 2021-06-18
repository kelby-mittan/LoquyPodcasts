//
//  LoquyListView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct LoquyListView: View {
    
    @ObservedObject var networkManager = ViewModel()
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var showActionSheet: Bool = false
    @State var loquies = [String?]()
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text(LoquyText.remove).font(.largeTitle).fontWeight(.bold), buttons: [
            .default(Text(LoquyText.cancel)) {
            },
            .destructive(Text(LoquyText.delete)) {
                Persistence.loquys.removeAll()
                networkManager.loadLoquys()
            }
            
        ])
    }
    
    var body: some View {
        
        if !networkManager.loquys.isEmpty {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 10) {
                        ForEach(loquies, id: \.self) { imageUrl in
                            VStack {
                                NavigationLink(destination: LoquyContentView(imageUrl: imageUrl ?? RepText.empty, networkManager: networkManager)) {
                                    
                                    RemoteImage(url: imageUrl ?? RepText.empty)
                                        .frame(width: 170, height: 170)
                                        .padding(2)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }.padding([.leading,.trailing],8)
                }
                .navigationBarTitle(LoquyText.loquyList)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            showActionSheet.toggle()
                                        }) {
                                            Image(systemName: Symbol.minus)
                                                .font(.title)
                                                .foregroundColor(.purple)
                                        }
                )
            }
            .actionSheet(isPresented: $showActionSheet, content: {
                actionSheet
            })
            .onAppear {
                networkManager.loadLoquys()
                loquies = Array(Set(networkManager.loquys.map { $0.audioClip.episode.imageUrl }))
            }
            .accentColor(.purple)
        } else {
            EmptySavedView(emptyType: .transcribedLoquy)
                .onAppear {
                    networkManager.loadLoquys()
                }
        }
        
    }
    
    
}

@available(iOS 14.0, *)
struct LoquyContentView: View {
    
    let imageUrl: String
    
    @ObservedObject var networkManager : ViewModel
    @State var toggled = false
    @State var page = 0
    
    var body: some View {
        
        VStack {
            if toggled {
                ZStack {
                    VStack {
                        GeometryReader{ g in
                            Carousel(networkManager: networkManager, imageUrl: imageUrl, width: UIScreen.main.bounds.width, page: $page, height: g.frame(in: .global).height)
                                .onAppear {
                                    networkManager.loadLoquys()
                                }
                        }
                        
                        PageControl(page: $page, loquyCount: networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count)
                            .background(NeoButtonView())
                            .padding([.bottom,.top], 8)
                        Spacer()
                    }
                }
                .transition(
                    AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                )
                .animation(Animation.interpolatingSpring(stiffness: 330, damping: 20.0, initialVelocity: 3.5))
                
            } else {
                ZStack {
                    VStack {
                        Spacer()
                        Text("\(networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.first?.audioClip.episode.author ?? "")")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding([.leading,.trailing,.top,.bottom])
                        
                        RemoteImage(url: imageUrl)
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(LoquyText.youHave) \(networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count) \(LoquyText.transripts)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                
                                Text(LoquyText.from)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                    .padding(.top, 4)
                                Text("\(networkManager.audioClips.filter { $0.episode.imageUrl ?? "" == imageUrl }.count) \(LoquyText.savedClips)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                    .padding(.top, 4)
                            }
                            .padding([.bottom,.leading])
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding([.trailing,.top])
                        
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                toggled = true
                            }) {
                                ZStack {
                                    NeoButtonView()
                                    Image(systemName: Symbol.quote).font(.largeTitle)
                                        .foregroundColor(.purple)
                                }.background(NeoButtonView())
                                .frame(width: 60, height: 60)
                                .clipShape(Capsule())
                                
                            }
                            .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                            .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                        }
                        
                    }.padding([.leading,.bottom,.trailing])
                    .background(CardNeoView(isRan: true))
                    .cornerRadius(12)
                }
                .padding([.leading,.trailing],12)
                .frame(height: UIScreen.main.bounds.height*2/3)
                .transition(
                    AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                )
                .animation(Animation.interpolatingSpring(stiffness: 330, damping: 20.0, initialVelocity: 3.5))
            }
            
        }
        .onAppear {
            networkManager.loadLoquys()
            networkManager.loadAudioClips()
        }
        
        .navigationBarHidden(false)
        .navigationBarTitle(RepText.empty,displayMode: .inline)
    }
}
