//
//  GlobalConstants.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/18/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI

public struct Symbol {
    static let magGlass = "magnifyingglass"
    static let play = "play.fill"
    static let pause = "pause.fill"
    static let minus = "minus"
    static let photo = "photo"
    static let star = "star.fill"
    static let speaker = "speaker.2.fill"
    static let bullet = "list.bullet"
    static let quote = "text.quote"
}

public struct HomeText {
    static let browse = "Browse"
    static let listenTo = "Listen To"
    static let moreCasts = "More Cool Casts"
    static let episodes = " episodes"
    static let favorites = "Favorites"
    static let clips = "Audio Clips"
    static let loquies = "Loquies"
}

public struct TimeText {
    static let zero = "0:00"
    static let dubZero = "00"
    static let colon = ":"
    static let unloaded = "--:--"
    static let dash = " - "
    static let mmddyy = "MMM dd, yyyy"
    static let timeFormat = "%02d:%02d:%02d"
}

public struct RepText {
    static let empty = ""
    static let transcribe = "transcribe"
    static let save = "save loquy"
    static let noTranscription = "could not get transcription"
    static let yourLoquy = "Your Loquy..."
    static let heyNow = "hey$now"
    static let favCasts = "Favorite Casts"
    static let podCellReuseId = "podcastCell"
    static let goBrowse = "Go Browse"
}

public struct LoquyText {
    static let remove = "Remove All Loquys?"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let loquyList = "Loquy List"
    static let youHave = "You have"
    static let transripts = "transcripts"
    static let from = "from"
    static let savedClips = "saved audio clips"
}

public struct TrimText {
    static let trimmedFile = "trimmedFile"
    static let m4a = ".m4a"
}

public struct ErrorText {
    static let recError = "recognition error: "
    static let deqPodCell = "could not dequeue Podcast Cell"
    static let gettingEpisodes = "error getting episodes: "
    static let savingClip = "error saving clip: "
    static let activatingSesh = "Failed to activate session:"
}

public struct ClipText {
    static let selected = "2:00"
    static let dubZero = "00:"
    static let titleLabel = "Title: "
    static let giveTitle = "give this clip a title"
    static let start = "start  "
    static let end = "end  "
    static let clipSaved = "clip saved"
    static let saveClip = "Save Clip"
}
