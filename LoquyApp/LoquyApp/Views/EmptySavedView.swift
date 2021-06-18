//
//  EmptySavedView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 10/9/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct EmptySavedView: View {
    
    let emptyType: EmptyType
    
    let universalSize = UIScreen.main.bounds
    @State var isAnimated = false
    
    var body: some View {
        
        ZStack {
            VStack {
                Image(emptyType.imageName)
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding([.top],20)
                Text(emptyType.message)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(height: 80, alignment: .center)
                    .padding([.leading,.trailing])
                
            }.offset(y: -universalSize.height/5)
            ZStack {
                getSineWave(interval: universalSize.width)
                    .foregroundColor(PaletteColour.purple.colour).opacity(0.6)
                    .offset(x: isAnimated ? -universalSize.width : 0)
                    .animation(
                        Animation.linear(duration: 2.5)
                            .repeatForever(autoreverses: false)
                    )
                getSineWave(interval: universalSize.width*1.4, amplitude: 165, baseLine: 50+universalSize.width/1.2)
                    .foregroundColor(PaletteColour.lighterPurple.colour).opacity(0.6)
                    .offset(x: isAnimated ? -universalSize.width*1.4 : 0)
                    .animation(
                        Animation.linear(duration: 4.5)
                            .repeatForever(autoreverses: false)
                    )
                getSineWave(interval: universalSize.width*1.1, amplitude: 130)
                    .foregroundColor(PaletteColour.lightPurple.colour).opacity(0.6)
                    .offset(x: isAnimated ? -universalSize.width*1.1 : 0)
                    .animation(
                        Animation.linear(duration: 3.5)
                            .repeatForever(autoreverses: false)
                    )
            }.onAppear {
                isAnimated = true
            }
        }
        
        
    }
    
    // resource: YouTube - ChrisLearns • IMMIX Concepts, LLC.
    
    func getSineWave(interval: CGFloat, amplitude: CGFloat = 100, baseLine: CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path({ path in
            path.move(to: CGPoint(x: 0, y: baseLine))
            path.addCurve(
                to: CGPoint(x: interval, y: baseLine),
                control1: CGPoint(x: interval*0.35, y: amplitude + baseLine),
                control2: CGPoint(x: interval*0.65, y: -amplitude + baseLine)
            )
            path.addCurve(
                to: CGPoint(x: 2*interval, y: baseLine),
                control1: CGPoint(x: interval*1.35, y: amplitude + baseLine),
                control2: CGPoint(x: interval*1.65, y: -amplitude + baseLine)
            )
            path.addLine(to: CGPoint(x: 2*interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        })
    }
}

struct EmptySavedView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySavedView(emptyType: .transcribedLoquy)
    }
}

enum EmptyType {
    case favorite, audioClip, transcribedLoquy
    
    var imageName: String {
        return self.getName().name
    }
    
    var message: String {
        return self.getName().message
    }

    func getName() -> (name: String, message: String) {
        switch self {
        case .favorite:
            return (EmptyViewText.favName, EmptyViewText.favMessage)
        case .audioClip:
            return (EmptyViewText.clipName, EmptyViewText.clipMessage)
        case .transcribedLoquy:
            return (EmptyViewText.loquyName, EmptyViewText.loquyMessage)
        }
    }
}
