//
//  PaletteColour.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

enum PaletteColour: String {
    case offWhite = "#f9f7e3"
    case lightBlue = "#d4ebf2"
    case lightGreen = "#a9bd95"
    case peach = "#e2a093"
    case pink = "#c67eb2"
    case darkBlue = "#3e54c7"
    case aqua = "#a1c5c5"
    case black = "#000000"
    
    var colour: Color {
        guard self.rawValue.count == 7 else { return Color.black }
        var hexTuple: (Int,Int,Int) = (0,0,0)
        hexTuple.0 = Int(self.rawValue[self.rawValue.index(self.rawValue.startIndex, offsetBy: 1)...self.rawValue.index(self.rawValue.startIndex, offsetBy: 2)], radix: 16) ?? 0
        hexTuple.1 = Int(self.rawValue[self.rawValue.index(self.rawValue.startIndex, offsetBy: 3)...self.rawValue.index(self.rawValue.startIndex, offsetBy: 4)], radix: 16) ?? 0
        hexTuple.2 = Int(self.rawValue[self.rawValue.index(self.rawValue.startIndex, offsetBy: 5)...self.rawValue.index(self.rawValue.startIndex, offsetBy: 6)], radix: 16) ?? 0
        return Color(red: Double(CGFloat(hexTuple.0)) / 255.0, green: Double(CGFloat(hexTuple.1)) / 255.0, blue: Double(CGFloat(hexTuple.2)) / 255.0)
    }
    
    static let colors1 = [ PaletteColour.pink.colour, PaletteColour.darkBlue.colour, PaletteColour.aqua.colour]
    
    static let colors2 = [PaletteColour.lightBlue.colour, PaletteColour.lightGreen.colour, PaletteColour.peach.colour]
}
