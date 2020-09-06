//
//  ControlView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 8/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit
import MediaPlayer
//import AVFoundation


struct ControlView: View {
    
    let episode: Episode
    
    @State var width : CGFloat = 10
    @State var playing = true
    @State var isFirstPlay = false
    @State var currentTime: String = "0:00"
    @State var isRecording = false
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .leading) {
                
                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 10)
                    .padding([.top,.leading,.trailing])
                
                Capsule().fill(Color.blue).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            
                            let x = value.location.x
                            let maxVal = UIScreen.main.bounds.width - 30
                            let minVal: CGFloat = 10
                            
                            if x < minVal {
                                self.width = minVal
                            } else if x > maxVal {
                                self.width = maxVal
                            } else {
                                self.width = x
                            }
                            self.currentTime = self.capsuleDragged(value.location.x).toDisplayString()
                            print("width val is : \(self.width)")
                            
                        }).onEnded({ (value) in
                            
                            self.player.seek(to: self.capsuleDragged(value.location.x))
                            
                        })).padding([.top,.leading,.trailing])
                
            }
            
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(getCurrentPlayerTime().durationTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding([.leading,.trailing])
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 10) {
                
                Button(action: {
                    Player.seekToCurrentTime(delta: -15, player: self.player)
                }) {
                    Image(systemName: "gobackward.15").font(.largeTitle)
                }
                
                Button(action: {
                    self.playing.toggle()
                    self.playing ? self.player.play() : self.player.pause()
                    
                }) {
                    Image(systemName: self.playing ? "pause.fill" : "play.fill").font(.largeTitle)
                }
                
                Button(action: {
                    Player.seekToCurrentTime(delta: 15, player: self.player)
                    
                }) {
                    
                    Image(systemName: "goforward.15").font(.largeTitle)
                    
                }
                
            }
            Button(action: {
                
                guard let streamURL = URL(string: self.episode.streamUrl) else {
                    print("COULD NOT GET STREAM URL")
                    return
                }
                let asset = AVAsset(url: streamURL)
                
                AudioTrim.exportAsset(asset: asset, fileName: "PLEASEWORK", stream: self.episode.streamUrl)
                
                
            }) {
                Image(systemName: "recordingtape").font(.largeTitle)
            }
            .padding(.top,25)
        }.onAppear {
            Player.playEpisode(episode: self.episode, player: self.player)
            self.getCurrentPlayerTime()
            
            print(self.episode.fileUrl ?? "error")
        }
    }
    
    /// Function determines the AVPlayer's current playing time and its percentage of the full podcast duration
    /// - Returns: CGFloat representing where the Capsule should be on the screen
    private func updateTimeCapsule() -> CGFloat {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return CGFloat(percentage)
    }
    
    /// Function determines where to seek to within a podcast based on a capsule drag
    /// - Parameter xVal: CGFloat determined from a Capsules x location
    /// - Returns: A CMTime to be used when seeking a certain time in a podcast
    @discardableResult
    private func capsuleDragged(_ xVal: CGFloat) -> CMTime {
        //        let x = value.location.x
        let screen = UIScreen.main.bounds.width - 30
        let percentage = xVal / screen
        
        guard let duration = self.player.currentItem?.duration else { return CMTime(value: 0, timescale: 0) }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        return seekTime
    }
    
    
    @discardableResult
    private func getCurrentPlayerTime() -> (currentTime: String, durationTime: String) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        var durationLabel = ""
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTime = time.toDisplayString()
        }
        let durationTime = self.player.currentItem?.duration
        guard let dt = durationTime else { return ("0:00","0:00") }
        durationLabel = dt.toDisplayString()
        return (currentTime,durationLabel)
    }
    
//    func trimAudio(asset: AVAsset, startTime: Double, stopTime: Double, finished:@escaping (URL) -> ()) {
//        
//        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith:asset)
//        
//        if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
//            
//            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
//                
//                print("ERROR CREATING EXPORT SESSION")
//                return
//                
//            }
//            
//            // Creating new output File url and removing it if already exists.
//            //            let furl = createUrlInAppDD("trimmedAudio.m4a") //Custom Function
//            guard let furl = createURLForNewRecord() else {
//                print("ERROR WITH URL")
//                return
//            }
//            //            removeFileIfExists(fileURL: furl) //Custom Function
//            
//            print("FILE URL: \(furl)")
//            
//            exportSession.outputURL = furl
//            exportSession.outputFileType = AVFileType.m4a
//            
//            let start: CMTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: asset.duration.timescale)
//            let stop: CMTime = CMTimeMakeWithSeconds(stopTime, preferredTimescale: asset.duration.timescale)
//            let range: CMTimeRange = CMTimeRangeFromTimeToTime(start: start, end: stop)
//            exportSession.timeRange = range
//            
//            exportSession.exportAsynchronously(completionHandler: {
//                
//                switch exportSession.status {
//                case .failed:
//                    print("Export failed: \(exportSession.error!.localizedDescription)")
//                case .cancelled:
//                    print("Export canceled")
//                default:
//                    print("Successfully trimmed audio")
//                    DispatchQueue.main.async(execute: {
//                        finished(furl)
//                    })
//                }
//            })
//        }
//    }
//    
//    func exportAsset(asset: AVAsset, fileName: String) {
//        print("\(#function)")
//        
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
//        print("saving to \(trimmedSoundFileURL.absoluteString)")
//        
//        if FileManager.default.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
//            print("sound exists, removing \(trimmedSoundFileURL.absoluteString)")
//            do {
//                if try trimmedSoundFileURL.checkResourceIsReachable() {
//                    print("is reachable")
//                }
//                
//                try FileManager.default.removeItem(atPath: trimmedSoundFileURL.absoluteString)
//            } catch {
//                print("could not remove \(trimmedSoundFileURL)")
//                print(error.localizedDescription)
//            }
//            
//        }
//        
//        print("creating export session for \(asset)")
//        
//        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
//            exporter.outputFileType = AVFileType.m4a
//            exporter.outputURL = trimmedSoundFileURL
//            
//            let duration = CMTimeGetSeconds(asset.duration)
//            if duration < 5.0 {
//                print("sound is not long enough")
//                return
//            }
//            // the first 5 seconds
//            let startTime = CMTimeMake(value: 0, timescale: 1)
//            let stopTime = CMTimeMake(value: 5, timescale: 1)
//            exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
//            
//            // do it
//            exporter.exportAsynchronously(completionHandler: {
//                print("export complete \(exporter.status)")
//                
//                switch exporter.status {
//                case  AVAssetExportSessionStatus.failed:
//                    
//                    if let e = exporter.error {
//                        print("export failed \(e)")
//                    }
//                    
//                case AVAssetExportSessionStatus.cancelled:
//                    print("export cancelled \(String(describing: exporter.error))")
//                default:
//                    print("export complete")
//                }
//            })
//        } else {
//            print("cannot create AVAssetExportSession for asset \(asset)")
//        }
//    }
//    
//    mutating func startRecording() {
//        guard let newFileURL = createURLForNewRecord() else {
//            print("Error")
//            return
//        }
//
//        do {
//
//            //                var urlString = URL(string: newFileURL)
//            //                urlString = newFileURL
//            audioRecorder = try AVAudioRecorder(url: newFileURL,
//                                                settings: [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
//                                                    AVSampleRateKey: 8000,
//                                                    AVNumberOfChannelsKey: 1,
//                                                    AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue])
//            //                audioRecorder.delegate = self
//            audioRecorder.prepareToRecord()
//            audioRecorder.record(forDuration: 60)
//        } catch {
//            print("RECORDING ERROR: \(error)")
//        }
//
//    }
//    
//    private func createURLForNewRecord() -> URL? {
//        guard let appGroupFolderUrl = FileManager.getAppFolderURL() else {
//            return nil
//        }
//        
//        let date = String(describing: Date())
//        let fullFileName = "LoquyClip" + date + ".m4a"
//        let newRecordFileName = appGroupFolderUrl.appendingPathComponent(fullFileName)
//        return newRecordFileName
//    }
}

extension FileManager {
    class func getAppFolderURL() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
