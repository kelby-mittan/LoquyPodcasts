//
//  AudioTrim.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer

struct AudioTrim {
    
    static func exportUsingComposition(streamUrl: String, start: String, end: String, pathForFile: String) {
        
        guard let url = URL(string: streamUrl) else {
            return
        }
        let assetItem = AVPlayerItem(url: url)
        
        let composition = AVMutableComposition()
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let sourceAudioTrack = assetItem.asset.tracks(withMediaType: AVMediaType.audio).first!
        
        do {
            try compositionAudioTrack?.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: assetItem.duration), of: sourceAudioTrack, at: CMTime.zero)
        } catch {
            print("failed exportUsingComposition: \(error)")
        }
        
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: composition)
        var preset: String = AVAssetExportPresetPassthrough
        if compatiblePresets.contains(AVAssetExportPresetAppleM4A) {
            preset = AVAssetExportPreset1920x1080 // can change preset here - see doc for more presets
            //preset = AVAssetExportPresetAppleM4A // does not work
        }
        
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: preset),
            exportSession.supportedFileTypes.contains(.mp4) else {
                fatalError("file type NOT supported")
        }
        
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedFileURL = documentsDir.appendingPathComponent("\(pathForFile).m4a")
        
        if FileManager.default.fileExists(atPath: trimmedFileURL.path) {
            print("file exists")
            try? FileManager.default.removeItem(at: trimmedFileURL)
        } else {
            print("file does not exist")
        }
        
        exportSession.outputURL = trimmedFileURL
        exportSession.outputFileType = .mp4
        
        let startDouble = start.toSecDouble()
        let endDouble = startDouble + end.toSecDouble()
        
        let startTime = CMTime(seconds: startDouble, preferredTimescale: 1)
        let stopTime = CMTime(seconds: endDouble, preferredTimescale: 1)
        
        exportSession.timeRange = CMTimeRange(start: startTime, end: stopTime)
        
        exportSession.exportAsynchronously {
            print("export complete \(exportSession.status)")
            switch exportSession.status {
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed \(exportSession.error?.localizedDescription ?? "")")
            case .exporting:
                print("exporting")
            case .completed:
                print("completed")
            case .waiting:
                print("waiting")
            case .unknown:
                print("unknown")
            default:
                print("future case")
            }
        }
    }
    
    static func loadUrlFromDiskWith(fileName: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            return url
            
        }
        
        return nil
    }
}

extension FileManager {
    class func getAppFolderURL() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
