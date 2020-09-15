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
    
    // https://www.rockhoppertech.com/blog/ios-trimming-audio-files/#:~:text=One%20way%20to%20trim%20an,in%20the%20soundFileURL%20instance%20variable.
    
    static func exportUsingComposition(streamUrl: String, pathForFile: String) {

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

      let startTime = CMTime(value: 0, timescale: 1)
      let stopTime = CMTime(value: 5, timescale: 1)
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
    
//    static func exportAsset(asset: AVAsset, fileName: String, stream: String) {
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
////        guard let streamURL = URL(string: stream) else {
////            print("NO STREAM URL")
////            return
////        }
////
////        let asset2 = AVMutableComposition(url: streamURL)
//        
//        
//        
//        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
//            exporter.outputFileType = AVFileType.m4a
//            
//            
////            print("HELLO: \((asset as? AVURLAsset)?.url.pathExtension)")
//            
//            let exportPath: NSString = NSTemporaryDirectory().appendingFormat("/video.mov") as NSString
//            let exportUrl: NSURL = NSURL.fileURL(withPath: exportPath as String) as NSURL
//            
//            exporter.outputURL = exportUrl as URL
//            
//            let duration = CMTimeGetSeconds(asset.duration)
//            if duration < 5.0 {
//                print("sound is not long enough")
//                return
//            }
//            // the first 5 seconds
//            let startTime = CMTimeMake(value: 0, timescale: 1)
//            let stopTime = CMTimeMake(value: 20, timescale: 1)
//            exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
////            dump(exporter.directoryForTemporaryFiles)
//            // do it
//            exporter.exportAsynchronously(completionHandler: {
//                print("export complete \(exporter.status)")
//                
////                switch exporter.status {
////                case  AVAssetExportSessionStatus.failed:
////
////                    if let e = exporter.error {
////                        print("export failed \(e)")
////                    }
////
////                case AVAssetExportSessionStatus.cancelled:
////                    print("export cancelled \(String(describing: exporter.error))")
////                default:
////                    print("export complete")
//                let data = try? Data(contentsOf: exportUrl as URL)
//                dump(data)
//                print(exporter.error)
////                }
//            })
//        } else {
//            print("cannot create AVAssetExportSession for asset \(asset)")
//        }
//    }
    
    static func trimAudio(asset: AVAsset, startTime: Double, stopTime: Double, finished:@escaping (URL) -> ()) {
        
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith:asset)
        
        if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
                
                print("ERROR CREATING EXPORT SESSION")
                return
                
            }
            
            // Creating new output File url and removing it if already exists.
            //            let furl = createUrlInAppDD("trimmedAudio.m4a") //Custom Function
            guard let furl = createURLForNewRecord() else {
                print("ERROR WITH URL")
                return
            }
            //            removeFileIfExists(fileURL: furl) //Custom Function
            
            print("FILE URL: \(furl)")
            
            exportSession.outputURL = furl
            exportSession.outputFileType = AVFileType.m4a
            
            let start: CMTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: asset.duration.timescale)
            let stop: CMTime = CMTimeMakeWithSeconds(stopTime, preferredTimescale: asset.duration.timescale)
            let range: CMTimeRange = CMTimeRangeFromTimeToTime(start: start, end: stop)
            exportSession.timeRange = range
            
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status {
                case .failed:
                    print("Export failed: \(exportSession.error!.localizedDescription)")
                case .cancelled:
                    print("Export canceled")
                default:
                    print("Successfully trimmed audio")
                    DispatchQueue.main.async(execute: {
                        finished(furl)
                    })
                }
            })
        }
    }
    
    
//    static func startRecording(_ audioRecorder: inout AVAudioRecorder) {
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
    static func createURLForNewRecord() -> URL? {
        guard let appGroupFolderUrl = FileManager.getAppFolderURL() else {
            return nil
        }

        let date = String(describing: Date())
        let fullFileName = "LoquyClip" + date + ".m4a"
        let newRecordFileName = appGroupFolderUrl.appendingPathComponent(fullFileName)
        return newRecordFileName
    }

}

extension FileManager {
    class func getAppFolderURL() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
