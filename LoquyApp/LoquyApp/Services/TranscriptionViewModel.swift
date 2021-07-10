//
//  TranscriptionViewModel.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 6/19/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine
import MediaPlayer
import Speech

class TranscriptionViewModel: ObservableObject {
    
    static let shared = TranscriptionViewModel()
        
    var speechRecognizer = SFSpeechRecognizer()
    
    var didChange = PassthroughSubject<TranscriptionViewModel, Never>()
        
    @Published var startedPlaying = 0 {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var currentTime = TimeText.zero {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var width: CGFloat = 30 {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var transcription = RepText.empty {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var playing = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isTranscribing = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var showAlert = false {
        didSet {
            didChange.send(self)
        }
    }
    
    public func handlePlay(_ audioClip: AudioClip) {
        startedPlaying += 1
        if startedPlaying == 1 {
            guard let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) else {
                return
            }

            Player.playAudioClip(url: url)
            playing = true
            
            Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { [weak self] time in
                self?.currentTime = time
            }

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                if self.playing {
                    if Player.shared.player.currentItem?.duration.toDisplayString() != TimeText.unloaded && self.width > 0.0 {
                        Player.getCapsuleWidth(width: &self.width, currentTime: self.currentTime)
                    }
                }
            }
        }
    }
    
    public func timeToDisplay() -> String {
        return Player.getCurrentPlayerTime(currentTime, startedPlaying > 0) { [weak self] time in
            self?.currentTime = time
        }
    }
    
    public func handleIsTranscribing(_ audioClip: AudioClip) {
        isTranscribing.toggle()
        if isTranscribing {
            handlePlay(audioClip)
            getTranscriptionOfClippedFile(audioClip)
        } else {
            Player.shared.player.pause()
            playing = false
            showAlert.toggle()
        }
    }
    
    public func getTranscriptionOfClippedFile(_ audioClip: AudioClip) {
        SFSpeechRecognizer.requestAuthorization { [weak self] (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + TrimText.m4a) {
                
                AudioTrim.trimUsingComposition(url: url, start: self?.currentTime ?? "00:00:00", duration: audioClip.duration, pathForFile: TrimText.trimmedFile) { (result) in
                    switch result {
                    case .success(let clipUrl):
                        let request = SFSpeechURLRecognitionRequest(url: clipUrl)
                        self?.speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, error) in
                            if let error = error {
                                print(ErrorText.recError+error.localizedDescription)
                            } else {
                                if self?.playing == true {
                                    self?.transcription = result?.bestTranscription.formattedString ?? RepText.empty
                                }
                            }
                        })
                    default:
                        break
                    }
                }
            }
        }
    }
    
}
