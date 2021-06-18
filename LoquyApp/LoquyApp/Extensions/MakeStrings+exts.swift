//
//  MakeStrings+exts.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

extension Date {
    func makeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeText.mmddyy
        return dateFormatter.string(from: self)
    }
}

extension Int {
    func asString() -> String {
        return String(self)
    }
}
