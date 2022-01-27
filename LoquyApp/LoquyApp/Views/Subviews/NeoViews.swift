//
//  NeoViews.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct NeoButtonView: View {
    
    @Binding var dominantColor: UIColor?
    
    var body: some View {
        ZStack {
            
            Color(dominantColor?.lighter(componentDelta: 0.45) ?? .black)
            
            Capsule()
                .foregroundColor(.white)
                .blur(radius: 4)
                .offset(x: -8, y: -8)
            Capsule()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color(dominantColor?.lighter(componentDelta: 0.35) ?? #colorLiteral(red: 0.8638685346, green: 0.8565297723, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(2)
                .blur(radius: 2)
        }
    }
}

struct CardNeoView: View {
    
    let isRan: Bool
    
    let gradColor1 = PaletteColour.darkBlue.colour
    let gradColor2 = PaletteColour.peach.colour
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9889873862, green: 0.9497770667, blue: 1, alpha: 1))
                .offset(x: -10, y: -10)
            LinearGradient(gradient: Gradient(colors: isRan ? [gradColor1, gradColor2] : [Color.purple,Color(#colorLiteral(red: 0.8037956357, green: 0.7081945539, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .padding(2)
                .blur(radius: 4)
        }
    }
}


