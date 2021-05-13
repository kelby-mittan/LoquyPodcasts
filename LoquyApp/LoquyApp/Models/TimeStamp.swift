//
//  TimeStamp.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct TimeStamp: Codable, Identifiable, Hashable {
    var id: UUID?
    let episode: Episode
    let time: String
}
