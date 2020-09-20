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
    @ObservedObject var networkManager: NetworkingManager
    
    @State var timeStamps = [TimeStamp]()
    let gradColor1 = PaletteColour.colors1.randomElement()
    let gradColor2 = PaletteColour.colors2.randomElement()
    
    @State var isFavorited = true
    @State var favToSave = ""
    @State var saveText = ""
    
    
    var body : some View {
        
        ZStack {
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.showAlert.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }).padding(.all,14)
                    
                }
                
                PCastHeaderLabelView(label: favToSave)
                    .padding(.bottom, 5)
                PCastHeaderLabelView(label: time)
                
                Button(action: {
                    if isFavorited {
                        showAlert.toggle()
                        let newTStamp = TimeStamp(episode: episode, time: time)
                        var stamps = UserDefaults.standard.savedTimeStamps()
                        stamps.append(newTStamp)
                        UserDefaults.standard.saveTheTimeStamp(timeStamp: newTStamp)
                        loadTimes(episode: episode)
                        networkManager.timeStamps.append(newTStamp.time)
                    } else {
                        self.showAlert.toggle()
                    }
                    
                }) {
                        Text(saveText)
                            .fontWeight(.bold)
                            .frame(width: 120,height: 40)
                            .foregroundColor(Color.purple)
                            .background(PaletteColour.offWhite.colour)
                            .clipShape(Capsule())
                            .padding()
                }                
                Spacer()
            }
        }.onAppear(perform: {
            self.isFavorited = UserDefaults.standard.savedEpisodes().contains(self.episode)
            
            if !self.isFavorited {
                self.favToSave = "⇩Fave to Save!⇩"
                self.saveText = "okay"
            } else {
                self.favToSave = "Save this time?"
                self.saveText = "save"
            }
        })
        .frame(width: 300, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [self.gradColor1!, self.gradColor2!]), startPoint: .top, endPoint: .bottomTrailing))
        .cornerRadius(20)
        
    }
    
    func loadTimes(episode: Episode) {
        networkManager.loadTimeStamps(for: episode)
    }
}

