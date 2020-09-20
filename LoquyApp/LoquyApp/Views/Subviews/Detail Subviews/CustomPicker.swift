//
//  CustomPicker.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/17/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import AVKit

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
        picker.selectRow(3, inComponent: 0, animated: true)
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
//            return getEndTimeArr(currentTime).count
            return timeIntervals.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            return getEndTimeArr(currentTime)[row]
            return timeIntervals[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 200, height: 50))
            view.backgroundColor = .systemPurple
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = timeIntervals[row]
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
            return 50
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = timeIntervals[row]
            print(currentTime)
        }
        
        func getEndTimeArr(_ currentTime: String) -> [String] {
            var endTimeArr = [String]()
            
            print("Current Time: \(currentTime)")
            
            var counterIncrements = 29.0
            
            for _ in 0..<10{
                let sec = currentTime.toSecDouble() + counterIncrements
                let cmTime = CMTime(seconds: sec, preferredTimescale: 1)
                let timeStr = cmTime.toDisplayString()
                //                timeStr = timeStr.replacingOccurrences(of: "00:", with: "")
                
                endTimeArr.append(timeStr)
                counterIncrements += 30.0
            }
            
            return endTimeArr
        }
    }
    
    
}

let timeIntervals = ["00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00",]