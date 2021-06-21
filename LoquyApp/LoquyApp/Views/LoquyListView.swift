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
    
    @ObservedObject var viewModel = ViewModel.shared
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var showActionSheet: Bool = false
    @State private var loquies = [String?]()
    
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text(LoquynClipText.remove).font(.largeTitle).fontWeight(.bold), buttons: [
            .default(Text(LoquynClipText.cancel)) {
            },
            .destructive(Text(LoquynClipText.delete)) {
                Persistence.loquys.removeAll()
                viewModel.loadLoquys()
            }
            
        ])
    }
    
    var body: some View {
        
        if !viewModel.loquys.isEmpty {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 10) {
                        ForEach(loquies, id: \.self) { imageUrl in
                            VStack {
                                NavigationLink(destination: LoquyContentView(imageUrl: imageUrl ?? RepText.empty)) {
                                    
                                    RemoteImage(url: imageUrl ?? RepText.empty)
                                        .frame(width: 170, height: 170)
                                        .padding(2)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }.padding([.leading,.trailing],8)
                }
                .navigationBarTitle(LoquynClipText.loquyList)
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
                viewModel.loadLoquys()
                loquies = Array(Set(viewModel.loquys.map { $0.audioClip.episode.imageUrl }))
            }
            .accentColor(.purple)
        } else {
            EmptySavedView(emptyType: .transcribedLoquy)
                .onAppear {
                    viewModel.loadLoquys()
                }
        }
        
    }
    
    
}

@available(iOS 14.0, *)
struct LoquyContentView: View {
    
    let imageUrl: String
    
    @ObservedObject private var viewModel = ViewModel.shared
    @State private var toggled = false
    @State private var page = 0
    
    var body: some View {
        
        VStack {
            if toggled {
                ZStack {
                    VStack {
//                        GeometryReader{ g in
//                            Carousel(imageUrl: imageUrl, width: UIScreen.main.bounds.width, page: $page, height: g.frame(in: .global).height)
//                                .onAppear {
//                                    viewModel.loadLoquys()
//                                }
                            PagingCardView(imageUrl: imageUrl)
//                        }

//                        PageControl(page: $page, loquyCount: viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count)
//                            .background(NeoButtonView())
//                            .padding([.bottom,.top], 8)
//                        Spacer()
//                    CardPageView2(imageUrl: imageUrl)
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
                        Text("\(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.first?.audioClip.episode.author ?? "")")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding([.leading,.trailing,.top,.bottom])
                        
                        RemoteImage(url: imageUrl)
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(LoquynClipText.youHave) \(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count) \(LoquynClipText.transripts)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                
                                Text(LoquynClipText.from)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                    .padding(.top, 4)
                                Text("\(viewModel.audioClips.filter { $0.episode.imageUrl ?? "" == imageUrl }.count) \(LoquynClipText.savedClips)")
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
            viewModel.loadLoquys()
            viewModel.loadAudioClips()
        }
        
        .navigationBarHidden(false)
        .navigationBarTitle(RepText.empty,displayMode: .inline)
    }
}
