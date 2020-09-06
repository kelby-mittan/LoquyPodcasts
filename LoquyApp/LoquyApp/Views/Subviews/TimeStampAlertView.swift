//
//  TimeStampAlertView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct TimeStampAlertView: View {
    
    @Binding var showAlert: Bool
    @Binding var timeStamp: String
//    @ObservedObject private var networkManager = NetworkingManager()
    
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    var body : some View {
        
        ZStack {
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.showAlert.toggle()
//                        self.networkManager.isShowAlert.toggle()
                    }, label: {
                                                
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }).padding(.all,10)
                    
                }
                PCastHeaderLabelView(label: timeStamp)
                Spacer()
            }
        }
        .frame(width: 300, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [self.gradColor1!, self.gradColor2!]), startPoint: .top, endPoint: .bottomTrailing))
        .cornerRadius(20)
        
    }
    
}

class TimeStampViewModel: ObservableObject {
    @Published var textValue: String = "Hello"
    @Published var enteredTextValue: String = "" {
        didSet {
            checkIfTextsMatch()
        }
    }
    @Published var textsMatch: Bool = false

    func checkIfTextsMatch() {
        self.textsMatch = textValue == enteredTextValue
    }
}

