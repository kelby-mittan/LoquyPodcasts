//
//  Carousel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct Carousel : UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        
        return Carousel.Coordinator(parent1: self)
    }
    
    @ObservedObject var networkManager: NetworkingManager
    var imageUrl: String
    var width: CGFloat
    @Binding var page : Int
    var height: CGFloat
    
    
    func makeUIView(context: Context) -> UIScrollView{
        
        // ScrollView Content Size...
        
        let total = width * CGFloat(networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        //1.0  For Disabling Vertical Scroll....
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        
        // Now Going to  embed swiftUI View Into UIView...
        
        let view1 = UIHostingController(rootView: PageList(page: $page, networkManager: networkManager, imageUrl: imageUrl))
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        
        view.addSubview(view1.view)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        
    }
    
    class Coordinator: NSObject,UIScrollViewDelegate{
        
        var parent: Carousel
        
        init(parent1: Carousel) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            
            self.parent.page = page
        }
    }
}

struct PageControl: UIViewRepresentable {
    
    @Binding var page: Int
    
    let loquyCount: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .purple
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = loquyCount
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
                
        DispatchQueue.main.async {
            
            uiView.currentPage = self.page
        }
    }
}

struct PageList: View {
    
    @Binding var page: Int
    
    @ObservedObject var networkManager: NetworkingManager
    
    var imageUrl: String
    
    var body: some View{
        
        HStack(spacing: 0){
            
            ForEach(networkManager.loquys.filter { $0.audioClip.episode.imageUrl == imageUrl }) { loquy in
                                                
                CardPageView(page: $page, imageUrl: loquy.audioClip.episode.imageUrl ?? "", networkManager: networkManager, data: loquy)
            }
        }
    }
}
