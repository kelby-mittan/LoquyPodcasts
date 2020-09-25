//
//  NeoViews.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct NeoButtonView: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8638685346, green: 0.8565297723, blue: 1, alpha: 1))
            
            Capsule()
                .foregroundColor(.white)
                .blur(radius: 4)
                .offset(x: -8, y: -8)
            Capsule()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9536944032, green: 0.9129546285, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(2)
                .blur(radius: 2)
        }
    }
}

struct CardNeoView: View {
    
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9889873862, green: 0.9497770667, blue: 1, alpha: 1))
                .offset(x: -10, y: -10)
            LinearGradient(gradient: Gradient(colors: [gradColor1!, gradColor2!]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .padding(2)
                .blur(radius: 4)
        }
    }
}


