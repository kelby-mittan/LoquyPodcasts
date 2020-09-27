//
//  Loquy.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/29/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct Loquy: Codable, Identifiable, Hashable {
    
    var id: UUID?
    let idInCollection: Int
    let title: String
    let transcription: String
    let audioClip: AudioClip
    
}
