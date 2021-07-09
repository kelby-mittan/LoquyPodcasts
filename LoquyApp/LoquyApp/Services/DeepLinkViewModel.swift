//
//  DeepLinkViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/9/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

class DeepLinkViewModel: ObservableObject {
        
    var didChange = PassthroughSubject<DeepLinkViewModel, Never>()
    
    @Published var appURL = URL(string: RepText.empty) {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var deepLinkEpisode = Episode(url: URL(string: RepText.empty)) {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isDeepLink = Bool() {
        didSet {
            didChange.send(self)
        }
    }
    
    let appStoreURL = URL(string: "https://apps.apple.com/us/app/loquy/id1532251878")!
    
    let podImage = UIImage(named: Assets.loquyImage)!
    
    /*
     let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
     
     appURLL = URL(string: appPath)
     
     attString = NSMutableAttributedString(string: "Check it out")
     attString.setAttributes([.link: appURLL!], range: NSMakeRange(attString.length-12, 12))
     */
    
    public func prepareDeepLinkURL(_ loquy: Loquy) {
        let appPath = "deeplink://loquyApp\(loquy.audioClip.feedUrl )loquyApp\(loquy.audioClip.episode.pubDate.description)loquyApp\(loquy.audioClip.startTime)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "deeplink://"
        
        appURL = URL(string: appPath)
    }
    
    public func loadDeepLinkEpisode(url: URL) {
        let deepLinkData = url.getURLComponents()
        
        ITunesAPI.shared.fetchSpecificEpisode(feedUrl: deepLinkData.feed, date: deepLinkData.pubDate) { [weak self] episode in
            DispatchQueue.main.async {
                self?.deepLinkEpisode = episode
                self?.deepLinkEpisode.deepLinkTime = deepLinkData.dlTime
                self?.isDeepLink = true
            }
        }
    }
}
