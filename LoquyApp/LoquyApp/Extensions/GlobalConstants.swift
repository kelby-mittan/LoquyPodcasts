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
    static let minus = "minus"
    static let photo = "photo"
    static let star = "star.fill"
    static let speaker = "speaker.2.fill"
    static let bullet = "list.bullet"
    static let quote = "text.quote"
    static let play = "play.fill"
    static let pause = "pause.fill"
    static let back = "gobackward.15"
    static let forward = "goforward.15"
    static let xmark = "xmark"
    static let share = "square.and.arrow.up"
}

public struct Assets {
    static let mindscape = "mindscape"
    static let loquyImage = "Loquy-Purple"
}

public struct HomeText {
    static let browse = "Browse"
    static let listenTo = "Listen To"
    static let moreCasts = "More Cool Casts"
    static let episodes = " episodes"
    static let favorites = "Favorites"
    static let clips = "Audio Clips"
    static let loquies = "Loquies"
    static let weThink = "We Think"
    static let youllLike = "You'll Like"
    static let mindscape = "Mindscape"
    static let sCarrol = "Sean Carroll"
    static let topCasts = "Top Podcasts"
    static let featured = "Featured"
}

public struct TimeText {
    static let zero = "0:00"
    static let dubZero = "00"
    static let colon = ":"
    static let unloaded = "--:--"
    static let dash = " - "
    static let mmddyy = "MMM dd, yyyy"
    static let timeFormat = "%02d:%02d:%02d"
    static let timeIntervals = ["00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00",]
}

public struct RepText {
    static let empty = ""
    static let timeStamp = "Timestamp"
    static let recordClip = "Record Clip"
    static let transcribe = "Transcribe"
    static let saveLoquy = "Save Loquy"
    static let noTranscription = "could not get transcription"
    static let yourLoquy = "Your Loquy..."
    static let heyNow = "hey$now"
    static let favCasts = "Favorite Casts"
    static let podCellReuseId = "podcastCell"
    static let goBrowse = "Go Browse"
    static let removeEpisode = "Remove Episode"
    static let episodeSaved = "Episode Saved"
    static let saveEpisode = "Save Episode"
    static let episodeRemoved = "Episode Removed"
}

public struct LoquynClipText {
    static let remove = "Remove All Loquys?"
    static let removeClip = "Remove Clip"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let loquyList = "Loquies"
    static let youHave = "You have"
    static let transripts = "transcripts"
    static let from = "from"
    static let savedClips = "saved audio clips"
    static let yourClips = "Your Audio Clips"
    static let titleForLoquy = "Title for Loquy"
    static let giveTitle = "Give this clip a title"
    static let saveText = "Save"
    static let loquySaved = "Loquy Saved"
    static let loquyTranscript = "Loquy Transcript:"
}

public struct TimeStampText {
    static let saveThisEpisode = "Save this episode"
    static let addTimeStamp = "To add a timestamp"
    static let ok = "Okay"
    static let saveThisTime = "Save this time?"
    static let save = "Save"
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
    static let giveTitle = "Give this clip a title"
    static let start = "Start  "
    static let end = "End  "
    static let clipSaved = "Clip Saved"
    static let saveClip = "Save Clip"
}

public struct EmptyViewText {
    static let favName = "favorite"
    static let favMessage = "Looks like you haven't saved any podcasts yet!"
    static let clipName = "audioClip"
    static let clipMessage = "You don't have any yet... Start saving audio clips from your favorite podcasts!"
    static let loquyName = "savedLoquy"
    static let loquyMessage = "Start transcribing some of your saved audio clips!"
}
