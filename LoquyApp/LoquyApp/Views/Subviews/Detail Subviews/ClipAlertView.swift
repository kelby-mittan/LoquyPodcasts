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
    
    @State var selected = ""
    
    var body: some View {
        
        VStack {
//            Text("00:57:20")
            
            CustomPicker(selected: self.$selected, currentTime: "00:57:20")
            
//            Text(selected)
            
        }
    }
}

struct ClipAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ClipAlertView()
    }
}

struct CustomPicker: UIViewRepresentable {
    
    @Binding var selected : String
    
    var currentTime: String

//    init(time: String) {
//        currentTime = time
////        selected = selected1
//    }
    
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
