//
//  Favorites.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/4/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)

struct FavoritesVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FavoritesViewController {
        let favoritesVC = FavoritesViewController()
        return favoritesVC
    }
    
    func updateUIViewController(_ uiViewController: FavoritesViewController, context: Context) {
        
    }
    
}
