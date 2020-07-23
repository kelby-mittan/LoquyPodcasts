//
//  Episode.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable, Identifiable {
    
    var id: UUID?
    
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let streamUrl: String
    
    var fileUrl: String?
    var imageUrl: String?
    
}
