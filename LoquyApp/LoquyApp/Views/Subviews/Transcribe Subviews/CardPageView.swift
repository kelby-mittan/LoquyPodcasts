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
    
    @State private var transcription: String = RepText.empty
    @State private var shareShown = false
        
    let podImage = UIImage(named: Assets.loquyImage)!
    
    @State var appURLL = URL(string: "")
    @State var attString = NSMutableAttributedString()
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
                        let appStoreURL = URL(string: "https://apps.apple.com/us/app/loquy/id1532251878")!
                        
                        if let url = appURLL {
                            ShareView(items: ["\n Something cool I heard on Loquy\n\n",loquy.title+"\n\n ",loquy.transcription+"\n \n ",url,appStoreURL,podImage])
                        }
                    }
                    .onAppear {
                        
                        let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
                        
                        appURLL = URL(string: appPath)
                        
                        attString = NSMutableAttributedString(string: "Check it out")
                        attString.setAttributes([.link: appURLL!], range: NSMakeRange(attString.length-12, 12))
                    }
                    .cornerRadius(8)
                    .padding()
                }
            }.tabViewStyle(PageTabViewStyle())
            
        }
        .onAppear {
            viewModel.loadLoquys()
            
    //                let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
    //
    //                let appURL = URL(string: appPath)!
    //
    //                print(appURL.absoluteString)
    //
//                    attString = NSMutableAttributedString(string: "Check it out")
//                    attString.setAttributes([.link: appURL], range: NSMakeRange(attString.length-12, 12))
            
        }
        .cornerRadius(12)
        
    }
    
    func getLoquys() {
        viewModel.loadLoquys()
    }
}


