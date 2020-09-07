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
    @Binding var time: String
    let episode: Episode
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
//                        self.networkManager.updateShowAlert(showAlert: self.showAlert)
                    }, label: {
                                                
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }).padding(.all,14)
                    
                }
                
                PCastHeaderLabelView(label: "Save this time?")
                    .padding(.bottom, 5)
                PCastHeaderLabelView(label: time)
                
                Button(action: {
                    self.showAlert.toggle()
                    let newTStamp = TimeStamp(episode: self.episode, time: self.time)
                    var stamps = UserDefaults.standard.savedTimeStamps()
                    stamps.append(newTStamp)
                    UserDefaults.standard.saveTheTimeStamp(timeStamp: newTStamp)
                }) {
                    Text("yes")
                        .fontWeight(.bold)
                        .frame(width: 120,height: 40)
                        .foregroundColor(Color.purple)
                        .background(PaletteColour.offWhite.colour)
                        .clipShape(Capsule())
                        .padding()
                }
//                .padding([.leading,.top],20)
                
                Spacer()
            }
        }
        .frame(width: 300, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [self.gradColor1!, self.gradColor2!]), startPoint: .top, endPoint: .bottomTrailing))
        .cornerRadius(20)
        
    }
    
}

