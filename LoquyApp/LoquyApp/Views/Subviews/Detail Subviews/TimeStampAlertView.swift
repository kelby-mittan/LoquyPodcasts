//
//  TimeStampAlertView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/6/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct TimeStampAlertView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var showAlert: Bool
    
    let time: String
    let episode: Episode
    
    @State var timeStamps = [TimeStamp]()
    @State var favToSave = RepText.empty
    @State var saveText = RepText.empty
    @State var dominantColor: UIColor?
    
    var body : some View {
        
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.25)) {
                            showAlert.toggle()
                        }
                    }, label: {
                        Image(systemName: Symbol.xmark)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .offset(y: 8)
                    })
                    .padding(.all,14)
                    
                }
                
                PCastHeaderLabelView(label: favToSave)
                    .padding(.bottom, 5)
                
                if !Persistence.episodes.hasItemBeenSaved(episode) {
                    PCastHeaderLabelView(label: TimeStampText.saveThisEpisode)
                        .padding(.bottom, 5)
                        .padding(.top, -5)
                }
                
                PCastHeaderLabelView(label: time)
                
                Button(action: {
                    if Persistence.episodes.hasItemBeenSaved(episode) {
                        
                        let newTStamp = TimeStamp(episode: episode, time: time)
                        
                        do {
                            try Persistence.timeStamps.createItem(newTStamp)
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        loadTimes(episode: episode)
                    }
                    
                    withAnimation(.easeOut(duration: 0.25)) {
                        showAlert.toggle()
                    }
                    
                }) {
                    Text(saveText)
                        .fontWeight(.bold)
                        .frame(width: 120,height: 40)
                        .foregroundColor(Color(dominantColor ?? .lightGray))
                        .background(NeoButtonView(dominantColor: $dominantColor))
                        .clipShape(Capsule())
                        .padding()
                }                
                Spacer()
            }
            .frame(width: 300, height: Persistence.episodes.hasItemBeenSaved(episode) ? 200 : 260)
            .background(Color(dominantColor ?? .lightGray))
            .cornerRadius(20)
            .shadow(color: Color(dominantColor ?? .lightGray), radius: 16, x: 10, y: 10)
            .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
            
        }
        .onAppear(perform: {
            
            if !Persistence.episodes.hasItemBeenSaved(episode) {
                favToSave = TimeStampText.addTimeStamp
                saveText = TimeStampText.ok
            } else {
                favToSave = TimeStampText.saveThisTime
                saveText = TimeStampText.save
            }
            
            viewModel.getDominantColor(episode.imageUrl ?? RepText.empty) { clr in
                dominantColor = clr
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.ultraThinMaterial)
    }
    
    private func loadTimes(episode: Episode) {
        viewModel.loadTimeStamps(for: episode)
    }
}

