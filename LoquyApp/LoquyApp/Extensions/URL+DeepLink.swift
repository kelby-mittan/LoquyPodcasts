//
//  URL+DeepLink.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/16/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import Foundation

extension URL {
    public func getURLComponents() -> (feed: String, pubDate: String, dlTime: String) {
        let components = self.absoluteString.components(separatedBy: "loquyApp")
        guard components.count == 4 else { return ("","","") }
        let feed = components[1].replacingOccurrences(of: "https//", with: "https://")
        let pubDate = components[2].removingPercentEncoding ?? ""
        let timeStamp = components[3].removingPercentEncoding ?? ""
        return (feed,pubDate,timeStamp)
    }
}
