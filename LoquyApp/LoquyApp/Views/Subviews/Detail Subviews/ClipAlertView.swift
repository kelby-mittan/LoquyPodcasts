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
    
    @State var selected = ""
    
    var body: some View {
        
        VStack {
            Text("\(clipTime)")
            
            CustomPicker(selected: self.$selected, currentTime: "00:57:20")
            
            //            Text(selected)
            
        }
    }
}

//struct ClipAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClipAlertView()
//    }
//}

struct CustomPicker: UIViewRepresentable {
    
    @Binding var selected : String
    
    var currentTime: String
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(theParent: self, time: currentTime)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        
        var parent: CustomPicker
        var currentTime: String
        
        init(theParent: CustomPicker, time: String) {
            parent = theParent
            currentTime = time
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return getEndTimeArr(currentTime).count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return getEndTimeArr(currentTime)[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 200, height: 60))
            view.backgroundColor = .systemPurple
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = getEndTimeArr(currentTime)[row]
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 2
            view.addSubview(label)
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - 200
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = getEndTimeArr(currentTime)[row]
        }
        
        func getEndTimeArr(_ currentTime: String = "00:00:00") -> [String] {
            var endTimeArr = [String]()
            
            var counterIncrements = 29.0
            
            for _ in 0..<9{
                let sec = currentTime.toSecDouble() + counterIncrements
                let cmTime = CMTime(seconds: sec, preferredTimescale: 1)
                var timeStr = cmTime.toDisplayString()
                //                timeStr = timeStr.replacingOccurrences(of: "00:", with: "")
                endTimeArr.append(timeStr)
                counterIncrements += 29.0
            }
            
            return endTimeArr
        }
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
    
    var modalHeight:CGFloat = 400
    
    
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
                                self.isShown = false
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
                        self.content()
                            .padding()
                            .padding(.bottom, 65)
                            .frame(width: UIScreen.main.bounds.size.width, height:modalHeight)
                            .clipped()
                    }
                    .offset(y: isShown ? ((self.dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
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

final class UserData: ObservableObject {
    @Published var showFullScreen = false
}
