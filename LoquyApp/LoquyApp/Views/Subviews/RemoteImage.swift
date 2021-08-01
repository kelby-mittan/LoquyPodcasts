//
//  RemoteImage.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct RemoteImage: View {
    
    
    
    var url: String
    
    @Binding var domColorReporter: PassthroughSubject<UIColor?, Never>
    
//    @Binding var domColor: UIColor?
    
    
    var body: some View {
//        AsyncImage(
//            url: url,
//            placeholder: { ActivityIndicator(style: .medium) },
//            image: { Image(uiImage: $0).resizable() }
//        )
        AsyncImage(url: url,
                   placeholder: { ActivityIndicator(style: .medium) },
                   image: { Image(uiImage: $0).resizable() },
                   domColorReporter: domColorReporter)
    }
}

struct RemoteImageDetail: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder: ActivityIndicator
    
    init(url: String, placeholder: ActivityIndicator = ActivityIndicator(style:.medium)) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
        
    }
    
    var body: some View {
        if let image = imageLoader.downloadImage {
            let newImage = Image(uiImage: image)
            return AnyView(newImage.resizable())
        }
        return AnyView(placeholder)
    }
}
