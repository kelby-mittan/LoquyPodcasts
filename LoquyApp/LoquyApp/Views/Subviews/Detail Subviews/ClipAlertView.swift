//
//  ClipAlertView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/15/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit

struct ClipAlertView: View {
    
    var clipTime: String
    let episode: Episode
    
    @State var selected = "02:00"
    @Binding var modalShown: Bool
    @Binding var notificationShown: Bool
    @State var titleText = ""
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Text("title: ")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.purple)
                    .padding(.leading)
                
                TextField("  give this clip a title", text: $titleText)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(8)
                    .padding(.trailing)
                    .frame(height: 44)
            }
            
            Text("start  \(clipTime)")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
                .offset(y: 10)
            
            CustomPicker(selected: $selected, currentTime: clipTime)
            
            Text("end  \(getEndTime())")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
                .offset(y: -10)
            
            Button(action: {
                print(("00:"+selected).toSecDouble())
                print(titleText)
                modalShown = false
                notificationShown.toggle()
                
                var timer = 0
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (value) in
                    timer += 1
                    if timer > 1 {
                        notificationShown = false
                    }
                }
                
                let newClip = AudioClip(episode: episode, title: titleText, duration: selected, startTime: clipTime, endTime: getEndTime(), savedDate: Date().dateToString())
                var audioClips = UserDefaults.standard.savedAudioClips()
                audioClips.append(newClip)
                UserDefaults.standard.saveTheClip(clip: newClip)
                
                AudioTrim.exportUsingComposition(streamUrl: episode.streamUrl, start: clipTime, end: "00:"+selected, pathForFile:  episode.title)
                
            }) {
                    Text("Save Clip")
                        .fontWeight(.heavy)
                        .frame(width: 240,height: 60)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                        .offset(y: -10)
            }
            
            Spacer()
        }
        Spacer()
    }
    
    func getEndTime() -> String {
    
        let timeSec = clipTime.toSecDouble() + ("00:"+selected).toSecDouble()
        
        return CMTime(seconds: timeSec, preferredTimescale: 1).toDisplayString()
    }
}


struct HalfModalView<Content: View> : View {
    
    
    @GestureState private var dragState = DragState.inactive
    @Binding var isShown:Bool
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = modalHeight * (2/3)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold{
            isShown = false
        }
    }
    
    var modalHeight:CGFloat = 300
    
    
    var content: () -> Content
    var body: some View {
        
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
        }
        .onEnded(onDragEnded)
        return Group {
            ZStack {
                //Background
                Spacer()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    .background(isShown ? Color.black.opacity( 0.5 * fractionProgress(lowerLimit: 0, upperLimit: Double(modalHeight), current: Double(dragState.translation.height), inverted: true)) : Color.clear)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isShown = false
                        }
                )
                
                //Foreground
                VStack{
                    Spacer()
                    ZStack{
                        Color.white.opacity(1.0)
                            .frame(width: UIScreen.main.bounds.size.width, height:modalHeight)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            content()
                            .padding()
                            .padding(.bottom, 65)
                            .frame(width: UIScreen.main.bounds.size.width, height:modalHeight)
                            .clipped()
                    }
                    .offset(y: isShown ? ((dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(drag)
                    
                    
                }
            }.edgesIgnoringSafeArea(.all)
        }
        
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}



func fractionProgress(lowerLimit: Double = 0, upperLimit:Double, current:Double, inverted:Bool = false) -> Double{
    var val:Double = 0
    if current >= upperLimit {
        val = 1
    } else if current <= lowerLimit {
        val = 0
    } else {
        val = (current - lowerLimit)/(upperLimit - lowerLimit)
    }
    
    if inverted {
        return (1 - val)
        
    } else {
        return val
    }
    
}
