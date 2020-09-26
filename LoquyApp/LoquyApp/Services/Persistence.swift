//
//  Persistence.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import DataPersistence

struct Persistence {
    static var episodes = DataPersistence<Episode>(filename: "favEpisodes.plist")
    static var artWork = DataPersistence<String>(filename: "artWork.plist")
    static var timeStamps = DataPersistence<TimeStamp>(filename: "timeStamps.plist")
    static var audioClips = DataPersistence<AudioClip>(filename: "audioClips.plist")
    static var loquys = DataPersistence<Loquy>(filename: "loquys.plist")
}
