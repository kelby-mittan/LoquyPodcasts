//
//  ImageLoader.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var downloadImage: UIImage?
    
//    static func == (lhs: ImageLoader, rhs: ImageLoader) -> Bool {
//            let lhsImage = lhs.downloadImage
//            let rhsImage = rhs.downloadImage
//            if (lhsImage == nil && rhsImage != nil) || (lhsImage != nil && rhsImage == nil) {
//                return false
//            } else {
//                return true
//            }
//    }
    
    func fetchImage(url:String) {
        guard let imageUrl = URL(string: url) else {
//            fatalError("url string is invalid")
            print("error")
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.downloadImage = UIImage(data: data)
            }
        }.resume()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}
