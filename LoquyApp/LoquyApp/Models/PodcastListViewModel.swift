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

class PodcastViewModel: ObservableObject {
    
    @Published var pcasts = [Podcast]()
    
    func getThePodcasts(search: String) {
        ITunesAPI.shared.loadPodcasts(searchText: search) { (podcasts) in
            DispatchQueue.main.async {
                self.pcasts = podcasts
            }
        }
    }
}

//class PodcastListViewModel: ObservableObject {
//
//    @Published var podcasts: [Podcast] = []
//    @Published var searchTerm: String = ""
//
//    init() {
//        getThePodcasts(search: searchTerm)
//    }
//
//    func getThePodcasts(search: String) {
//        ITunesAPI.shared.loadPodcasts(searchText: search) { (podcasts) in
//            DispatchQueue.main.async {
//                self.podcasts = podcasts
//            }
//        }
//    }
//
//}
