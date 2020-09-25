//
//  RemoteImage.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

struct RemoteImage: View {
    
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

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "")
    }
}
