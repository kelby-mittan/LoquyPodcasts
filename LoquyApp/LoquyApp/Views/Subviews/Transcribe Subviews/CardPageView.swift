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
    
    @ObservedObject var viewModel = ViewModel.shared
    @ObservedObject var deepLinkViewModel = DeepLinkViewModel()
    
    @State private var shareShown = false
    @State var domColor: UIColor?
    
    var body: some View {
        
        ZStack {
            TabView {
                ForEach(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }, id: \.self) { loquy in
                    
                    if domColor != nil {
                        CardScrollView(loquy: loquy, shareShown: $shareShown, domColor: domColor)
                            .sheet(isPresented: $shareShown) {
                                if let url = deepLinkViewModel.appURL {
                                    ShareView(items: ["\n Something cool I heard on Loquy\n\n",loquy.title+"\n\n ",loquy.transcription+"\n \n ",url,deepLinkViewModel.appStoreURL,deepLinkViewModel.metaData,deepLinkViewModel.podImage])
                                }
                            }
                            .onAppear {
                                deepLinkViewModel.prepareDeepLinkURL(loquy)
                            }
                        .cornerRadius(8)
                        .padding()
                    }
                    
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
        }
        .cornerRadius(12)
        .onAppear {
            viewModel.getDomColor(imageUrl) { clr in
                domColor = clr
            }
        }
        
    }
    
}


