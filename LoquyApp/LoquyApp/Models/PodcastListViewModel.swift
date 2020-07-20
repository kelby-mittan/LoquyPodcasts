//
//  PodcastListViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PodcastListViewModel: ObservableObject {
    
//    var didChange = PassthroughSubject<PodcastListViewModel,Never>()
    
    @Published var podcasts: [Podcast] = []
    
    func getThePodcasts(search: String) {
        ITunesAPI.shared.getPodcasts(searchText: search) { (podcasts) in
            
            DispatchQueue.main.async {
                self.podcasts = podcasts
            }
        }
    }
    
//    init() {
//        ITunesAPI.shared.getPodcasts(searchText: "joerogan", completionHandler: { (podcasts) in
//            self.podcasts = podcasts
//        })
//    }
}
