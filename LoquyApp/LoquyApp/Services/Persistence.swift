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
    static var episodePersistence = DataPersistence<Episode>(filename: "favEpisodes.plist")
}
