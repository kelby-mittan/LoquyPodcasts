//
//  AudioClip.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/20/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct AudioClip: Codable, Identifiable, Hashable {
    var id: UUID?
    let episode: Episode
    let title: String
    let duration: String
    let startTime: String
    let endTime: String
    let savedDate: String
    let feedUrl: String
}
