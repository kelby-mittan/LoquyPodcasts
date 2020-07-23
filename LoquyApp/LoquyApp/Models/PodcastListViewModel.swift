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

class NetworkingManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkingManager, Never>()
    
    @Published var podcasts = [Podcast]() {
        didSet {
            didChange.send(self)
        }
    }
    
//    var search = String() {
//        didSet {
//            didChange.send(self)
//        }
//    }
    
    func updatePodcasts(forSearch: String) {
        ITunesAPI.shared.fetchPodcasts(searchText: forSearch) { (podcasts) in
            DispatchQueue.main.async {
                self.podcasts = podcasts
            }
        }
    }
}

class ImageFetcher: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    
    var data: Data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
            
        }.resume()
    }
}
