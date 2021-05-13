//
//  CMTime.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 8/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
    
}

extension String {
    func getCMTime() -> CMTime {
        let secArr = self.components(separatedBy: ":")
        var sec: Double = 1
        for (i,time) in secArr.enumerated() {
            if time == "00" {
                continue
            }
            switch i {
            case 0:
                sec += (Double(time) ?? 0.0) * 3600
            case 1:
                sec += (Double(time) ?? 0.0) * 60
            case 2:
                sec += (Double(time) ?? 0.0)
            default:
                break
            }
        }
        return CMTime(seconds: sec, preferredTimescale: 1)
    }
    
    func toSecDouble() -> Double {
        let secArr = self.components(separatedBy: ":")
        var sec: Double = 1
        for (i,time) in secArr.enumerated() {
            if time == "00" {
                continue
            }
            switch i {
            case 0:
                sec += (Double(time) ?? 0.0) * 3600
            case 1:
                sec += (Double(time) ?? 0.0) * 60
            case 2:
                sec += (Double(time) ?? 0.0)
            default:
                break
            }
        }
        return sec
    }
}
