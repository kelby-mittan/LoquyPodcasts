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
    @State var imgToShare: UIImage = UIImage(systemName: "photo")!
    
    var body: some View {
        
        ZStack {
            TabView {
                ForEach(viewModel.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }, id: \.self) { loquy in
                    
                        CardScrollView(loquy: loquy, shareShown: $shareShown)
                            .sheet(isPresented: $shareShown) {
                                                                
                                if let url = deepLinkViewModel.appURL {
                                    ShareView(items: [imgToShare,
                                                      url])
                                }
                            }
                            .cornerRadius(8)
                            .padding()
                            .onAppear {
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
            
        }
        .cornerRadius(12)
        
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
            
//            Spacer()
        }
        .padding()
        .frame(width: 400, height: 400)
        .background(Color(UIColor.color(withCodedString: loquy.audioClip.domColor ?? RepText.empty) ?? .clear))
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

extension View {

    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
}
