//
//  RemoteImage.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct RemoteImage: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder: Image
    
    
    
    init(url: String, placeholder: Image = Image(systemName: "hourglass")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    
    var body: some View {
        
        
        if let image = self.imageLoader.downloadImage {
            
            let newImage = Image(uiImage: image)
            
            return newImage.resizable()
        }
        return placeholder
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "")
    }
}
