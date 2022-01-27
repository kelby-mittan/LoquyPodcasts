//
//  CardPageView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI


struct PagingCardView: View {
        
    let imageUrl: String
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var deepLinkViewModel: DeepLinkViewModel
        
    @State private var shareShown = false
    @State var imgToShare: UIImage = UIImage(systemName: "photo")!
    @State var dominantColor: UIColor?
    
    var body: some View {
        
        ZStack {
            TabView {
                ForEach(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }, id: \.self) { loquy in
                    
                    CardScrollView(loquy: loquy, shareShown: $shareShown)
                        .sheet(isPresented: $shareShown) {
                                                            
                            ShareView(items: [imgToShare])
                            
                        }
                        .cornerRadius(8)
                        .padding()
                        .onAppear {
                            dominantColor = UIColor.color(withCodedString: loquy.audioClip.dominantColor ?? RepText.empty)
                            deepLinkViewModel.prepareDeepLinkURL(loquy)
                            DispatchQueue.main.async {
                                imgToShare = LoquyToShareView(loquy: loquy)
                                    .edgesIgnoringSafeArea(.all)
                                    .snapshot()
                            }
                        }
                        .environmentObject(viewModel)
                                                
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            shareButton
        }
        .cornerRadius(12)
        
    }
    
    @ViewBuilder var shareButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    shareShown = true
                }) {
                    ZStack {
                        NeoButtonView(dominantColor: $dominantColor)
                        Image(systemName: Symbol.share)
                            .font(.title)
                            .foregroundColor(Color(dominantColor ?? .white))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Capsule())
                }
                .padding([.trailing,.bottom])
            }
        }
        .padding([.horizontal,.bottom])
    }
    
}


struct LoquyToShareView: View {
    
    var loquy: Loquy
    
    @State var showImage = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RemoteImage(url: loquy.audioClip.episode.imageUrl ?? RepText.empty)
                    .frame(width: 100, height: 100)
                    .cornerRadius(6)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text("Episode: \(loquy.audioClip.episode.title)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("\(loquy.audioClip.startTime) - \(loquy.audioClip.endTime)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, 4)
                    
                }
            }
            .padding()
            
            Text(loquy.transcription)
                .font(.system(size: getBestFontSize(for: loquy.transcription), weight: .bold, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
            
        }
        .padding()
        .frame(width: 400, height: 400)
        .background(Color(UIColor.color(withCodedString: loquy.audioClip.dominantColor ?? RepText.empty) ?? .clear))
    }
    
    
    
    func getBestFontSize(for title: String) -> CGFloat {
        switch title.count {
        case 0..<5:
            return 62
        case 5..<20:
            return 38
        case 20..<70:
            return 32
        case 70..<120:
            return 26
        case 120..<200:
            return 22
        case 200..<330:
            return 16
        case 330..<600:
            return 12
        case 600..<900:
            return 10
        case 900..<1600:
            return 8
        case 1600..<2800:
            return 6
        default:
            return 4
        }
    }
}
