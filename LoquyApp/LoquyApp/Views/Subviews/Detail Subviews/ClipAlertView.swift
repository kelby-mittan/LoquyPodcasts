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
    
    @EnvironmentObject var viewModel: ViewModel
    
    var clipTime: String
    let episode: Episode
    let feedUrl: String?
    
    @Binding var modalShown: Bool
    @Binding var notificationShown: Bool
    @Binding var message: String
    
    
    @State var selected = ClipText.selected
    @State var titleText = RepText.empty
    @State var domColor: UIColor?
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Text(ClipText.titleLabel)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.vertical,8)
                    
                TextField(ClipText.giveTitle, text: $titleText)
                        .font(.headline)
                    .foregroundColor(Color(domColor?.darker() ?? .darkGray))
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .textFieldStyle(SuperCustomTextFieldStyle())
                
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color(domColor ?? .lightGray))
            .cornerRadius(12)
            
            Text(ClipText.start+clipTime)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color(domColor ?? .lightGray))
                .offset(y: 10)
            
            CustomPicker(selected: $selected, currentTime: clipTime, domColor: $domColor)
            
            Text(ClipText.end+getEndTime())
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color(domColor ?? .lightGray))
                .offset(y: -10)
            
            Button(action: {
                modalShown = false
                notificationShown = true
                message = ClipText.clipSaved
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (value) in
                    notificationShown = false
                }
                
                let clr = domColor?.codedString
                
                let newClip = AudioClip(episode: episode, title: titleText, duration: selected, startTime: clipTime, endTime: getEndTime(), savedDate: Date().dateToString(), feedUrl: feedUrl ?? RepText.empty, domColor: clr)
                
                do {
                    try Persistence.audioClips.createItem(newClip)
                } catch {
                    print(ErrorText.savingClip+error.localizedDescription)
                }
                
                AudioTrim.exportUsingComposition(streamUrl: episode.streamUrl, start: clipTime, duration: ClipText.dubZero+selected, pathForFile:  episode.title+clipTime)
                
                titleText = RepText.empty
                viewModel.loadAudioClips()
            }) {
                Text(ClipText.saveClip)
                        .fontWeight(.heavy)
                        .frame(width: 240,height: 60)
                        .foregroundColor(Color(domColor ?? .lightGray))
                        .background(NeoButtonView(domColor: $domColor))
                        .clipShape(Capsule())
                        .padding()
                        .offset(y: -10)
            }
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        .background(Color(.secondarySystemBackground))
        .onAppear {
            viewModel.getDomColor(episode.imageUrl ?? "") { clr in
                domColor = clr
            }
        }
        Spacer()
    }
    
    private func getEndTime() -> String {
    
        let timeSec = clipTime.toSecDouble() + (ClipText.dubZero+selected).toSecDouble()
        
        return CMTime(seconds: timeSec, preferredTimescale: 1).toDisplayString()
    }
}


struct HalfModalView<Content: View> : View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var isShown:Bool
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = modalHeight * (2/3)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold {
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
                    .cornerRadius(12)
                    .offset(y: isShown ? ((dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(drag)
                    
                    
                }
            }.edgesIgnoringSafeArea(.all)
        }
        
    }
    
    private func fractionProgress(lowerLimit: Double = 0, upperLimit:Double, current:Double, inverted:Bool = false) -> Double{
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


struct SuperCustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .frame(height: 34)
    }
}
