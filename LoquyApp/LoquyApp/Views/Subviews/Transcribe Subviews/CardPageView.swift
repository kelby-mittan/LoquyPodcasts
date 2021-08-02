//
//  CardPageView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)

struct PagingCardView: View {
        
    let imageUrl: String
    @EnvironmentObject var viewModel: ViewModel
    @ObservedObject var deepLinkViewModel = DeepLinkViewModel()
    
    @State private var shareShown = false
    
    var body: some View {
        
        ZStack {
            TabView {
                ForEach(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }, id: \.self) { loquy in
                    
                        CardScrollView(loquy: loquy, shareShown: $shareShown)
                            .sheet(isPresented: $shareShown) {
                                if let url = deepLinkViewModel.appURL {
                                    ShareView(items: ["\n Something cool I heard on Loquy\n\n",loquy.title+"\n\n ",loquy.transcription+"\n \n ",url,deepLinkViewModel.appStoreURL,deepLinkViewModel.metaData,deepLinkViewModel.podImage])
                                }
                            }
                            .cornerRadius(8)
                            .padding()
                            .onAppear {
                                deepLinkViewModel.prepareDeepLinkURL(loquy)
                            }
                            .environmentObject(viewModel)
                                                
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
        }
        .cornerRadius(12)
        
    }
    
}


