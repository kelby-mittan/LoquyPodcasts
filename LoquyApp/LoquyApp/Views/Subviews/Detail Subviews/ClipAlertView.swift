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
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ClipAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ClipAlertView()
    }
}

struct CustomPicker: UIViewRepresentable {
    
    
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
        
        init(theParent: CustomPicker) {
            parent = theParent
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            <#code#>
        }
    }
    
    func getEndTimeArr(_ currentTime: String) -> [String] {
        var endTimeArr = [String]()
        
        var counterIncrements = 30.0
        
        for _ in 0..<9{
            let sec = currentTime.toSecDouble() + counterIncrements
            let cmTime = CMTime(seconds: sec, preferredTimescale: 1)
            endTimeArr.append(cmTime.toDisplayString())
            counterIncrements += 30.0
        }
        
        return endTimeArr
    }
}
