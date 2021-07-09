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
    
    var body: some View {
        
        ZStack {
            TabView {
                ForEach(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }, id: \.self) { loquy in
                    
                    let gradColor1 = PaletteColour.colors1.randomElement()
                    let gradColor2 = PaletteColour.colors2.randomElement()
                    
                    ZStack {
                        
                        LinearGradient(gradient: Gradient(colors: [gradColor1!, gradColor2!]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        CardScrollView(loquy: loquy, shareShown: $shareShown)
                    }
                    .sheet(isPresented: $shareShown) {
                        
                        if let url = deepLinkViewModel.appURL {
                            ShareView(items: ["\n Something cool I heard on Loquy\n\n",loquy.title+"\n\n ",loquy.transcription+"\n \n ",url,deepLinkViewModel.appStoreURL,deepLinkViewModel.podImage])
                        }
                    }
                    .onAppear {
                        deepLinkViewModel.prepareDeepLinkURL(loquy)
                    }
                    .cornerRadius(8)
                    .padding()
                }
            }.tabViewStyle(PageTabViewStyle())
            
        }
        .cornerRadius(12)
        
    }
    
}


