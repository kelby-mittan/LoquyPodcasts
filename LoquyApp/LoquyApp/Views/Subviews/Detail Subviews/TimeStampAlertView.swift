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
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .offset(y: 8)
                    }).padding(.all,14)
                    
                }
                
                PCastHeaderLabelView(label: favToSave)
                    .padding(.bottom, 5)
                
                if !Persistence.episodes.hasItemBeenSaved(episode) {
                    PCastHeaderLabelView(label: "save this episode")
                        .padding(.bottom, 5)
                        .padding(.top, -5)
                }
                
                PCastHeaderLabelView(label: time)
                
                Button(action: {
                    if Persistence.episodes.hasItemBeenSaved(episode) {
                        showAlert.toggle()
                        let newTStamp = TimeStamp(episode: episode, time: time)
                        
                        do {
                            try Persistence.timeStamps.createItem(newTStamp)
                        } catch {
                            print("error saving timestamp: \(error)")
                        }
                        
                        loadTimes(episode: episode)
                    } else {
                        self.showAlert.toggle()
                    }
                    
                }) {
                        Text(saveText)
                            .fontWeight(.bold)
                            .frame(width: 120,height: 40)
                            .foregroundColor(Color.purple)
                            .background(NeoButtonView())
                            .clipShape(Capsule())
                            .padding()
                }                
                Spacer()
            }
//            .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 16, x: 10, y: 10)
//            .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
            
        }
        .onAppear(perform: {
            
            if !Persistence.episodes.hasItemBeenSaved(episode) {
                favToSave = "To add a timestamp"
                saveText = "okay"
            } else {
                favToSave = "Save this time?"
                saveText = "save"
            }
        })
        .frame(width: 300, height: Persistence.episodes.hasItemBeenSaved(episode) ? 200 : 260)
        .background(CardNeoView(isRan: true))
        .cornerRadius(20)
        .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 16, x: 10, y: 10)
        .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
    }
    
    private func loadTimes(episode: Episode) {
        networkManager.loadTimeStamps(for: episode)
    }
}

