//
//  Date.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/20/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y" //E, 
        return formatter.string(from: self)
    }
}
