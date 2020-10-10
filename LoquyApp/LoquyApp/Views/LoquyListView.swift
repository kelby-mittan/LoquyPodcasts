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
    
    @ObservedObject var networkManager = NetworkingManager()
    
    let podcasts = DummyPodcast.podcasts
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var showActionSheet: Bool = false
    
    var body: some View {
        
        if !networkManager.loquys.isEmpty {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 10) {
                        ForEach(Array(Set(networkManager.loquys.map { $0.audioClip.episode.imageUrl })), id: \.self) { imageUrl in
                            VStack {
                                NavigationLink(destination: LoquyContentView(imageUrl: imageUrl ?? "", networkManager: networkManager)) {
                                    
                                    
                                    RemoteImage(url: imageUrl ?? "")
                                        .frame(width: 170, height: 170)
                                        .padding(2)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }.padding([.leading,.trailing],8)
                }
                .navigationBarTitle("Loquy List")
                .navigationBarItems(trailing:
                                        Button(action: {
                                            
                                            showActionSheet.toggle()
                                            
                                        }) {
                                            ZStack {
                                                NeoButtonView()
                                                Image(systemName: "minus").font(.title)
                                                    .foregroundColor(.purple)
                                            }.background(NeoButtonView())
                                            .frame(width: 50, height: 50)
                                            .clipShape(Capsule())
                                            
                                        }
                    .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                                        .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                                        .offset(y: 15.0)
                )
            }
            .actionSheet(isPresented: $showActionSheet, content: {
                actionSheet
            })
            .onAppear(perform: {
                getLoquyTranscriptions()
            })
        } else {
            EmptySavedView(emptyType: .transcribedLoquy)
                .onAppear {
                    getLoquyTranscriptions()
                }
        }
        
        
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Remove All Loquys?").font(.largeTitle).fontWeight(.bold), buttons: [
            .default(Text("Cancel")) {
            },
            .destructive(Text("Delete")) {
                Persistence.loquys.removeAll()
                networkManager.loadLoquys()
            }
            
        ])
    }
    
    func getLoquyTranscriptions() {
        networkManager.loadLoquys()
    }
}

struct LoquyListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            LoquyListView()
        } else {
            Text("upgrade to iOS 14")
        }
    }
}


struct LoquyContentView: View {
    
    @State var page = 0
    
    let imageUrl: String
    
    @ObservedObject var networkManager : NetworkingManager
    
    @State var toggled = false
    
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
                                Text("You have \(networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count) transcripts")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                
                                Text("from")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                    .padding(.top, 4)
                                Text("\(networkManager.audioClips.filter { $0.episode.imageUrl ?? "" == imageUrl }.count) saved audio clips")
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
                                    Image(systemName: "text.quote").font(.largeTitle)
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
            
        }.onAppear(perform: {
            getLoquyTranscriptions()
            getAudioClips()
            
        })
        
        .navigationBarHidden(false)
        .navigationBarTitle("",displayMode: .inline)
    }
    
    private func getLoquyTranscriptions() {
        networkManager.loadLoquys()
    }
    
    private func getAudioClips() {
        networkManager.loadAudioClips()
    }
}
