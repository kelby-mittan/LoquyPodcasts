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
    
    
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    
    var body: some View {
        
        /*
         Image(podcast.image)
         .renderingMode(.original)
         .resizable()
         .aspectRatio(contentMode: .fit)
         .frame(width: width, height: height)
         .cornerRadius(12)
         .padding()
         */
        
        
        if let image = self.imageLoader.downloadImage {
            
            var newImage = Image(uiImage: image)
            
//            newImage = newImage.resizable()
//            newImage.frame(width: 100, height: 100)
            
//            return Image(uiImage: image)
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
