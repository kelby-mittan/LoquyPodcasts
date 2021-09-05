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
    
    @Binding var domColor: UIColor?
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(theParent: self, time: currentTime, domColor: $domColor)
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
        @Binding var domColor: UIColor?
        
        init(theParent: CustomPicker, time: String, domColor: Binding<UIColor?>) {
            parent = theParent
            currentTime = time
            _domColor = domColor
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return TimeText.timeIntervals.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return TimeText.timeIntervals[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 200, height: 50))
            view.backgroundColor = domColor
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = TimeText.timeIntervals[row]
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
            self.parent.selected = TimeText.timeIntervals[row]
        }
        
        func getEndTimeArr(_ currentTime: String) -> [String] {
            var endTimeArr = [String]()
            var counterIncrements = 29.0
            
            for _ in 0..<10{
                let sec = currentTime.toSecDouble() + counterIncrements
                let cmTime = CMTime(seconds: sec, preferredTimescale: 1)
                let timeStr = cmTime.toDisplayString()
                
                endTimeArr.append(timeStr)
                counterIncrements += 30.0
            }
            
            return endTimeArr
        }
    }
    
    
}

