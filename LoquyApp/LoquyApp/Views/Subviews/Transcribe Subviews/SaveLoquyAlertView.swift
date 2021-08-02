//
//  SaveLoquyAlertView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct SaveLoquyAlertView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var showAlert: Bool
    @Binding var notificationShown: Bool
    @Binding var message: String
    
    let audioClip: AudioClip
    let transcription: String
    let isPlaying: Bool

    @State var timeStamps = [TimeStamp]()
    @State var titleText = ""
    @State var domColor: UIColor?
    
    var body : some View {
        
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showAlert.toggle()
                        
                    }, label: {
                        Image(systemName: Symbol.xmark)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .font(.headline)
                            .offset(x: -8, y: 16)
                    })
                    .padding(.all,14)
                    
                }
                PCastHeaderLabelView(label: LoquynClipText.titleForLoquy)
                        .padding(.bottom, 5)
                   
                TextField(LoquynClipText.giveTitle, text: $titleText)
                        .font(.headline)
                        .foregroundColor(.purple)
                        .background(Color.white)
                        .cornerRadius(8)
                    .padding(.horizontal)
                        .frame(height: 44)
                        .textFieldStyle(SuperCustomTextFieldStyle())
                    
                    Button(action: {
                        showAlert.toggle()
                        saveLoquyToList()
                        handleNotification()
                    }) {
                        Text(LoquynClipText.saveText)
                            .fontWeight(.bold)
                            .frame(width: 120,height: 40)
                            .foregroundColor(Color.purple)
                            .background(NeoButtonView())
                            .clipShape(Capsule())
                            .padding()
                    }
                
                Spacer()
            }
            
        }
        .frame(width: 300, height: 200)
        .background(Color(domColor ?? .clear))
        .cornerRadius(20)
        .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 16, x: 10, y: 10)
        .shadow(color: Color(.white), radius: 16, x: -12, y: -12)
        .onAppear {
            viewModel.loadLoquys()
            viewModel.getDomColor(audioClip.episode.imageUrl ?? RepText.empty) { clr in
                domColor = clr
            }
        }
    }
    
    private func saveLoquyToList() {
        var id = 1
        let filteredLoquys = viewModel.loquys.filter { $0.audioClip.episode.imageUrl == audioClip.episode.imageUrl }
        
        if !filteredLoquys.isEmpty {
            id = filteredLoquys.count + 1
        }
        let newLoquy = Loquy(idInCollection: id, title: titleText, transcription: transcription, audioClip: audioClip)
        
        do {
            try Persistence.loquys.createItem(newLoquy)
        } catch {
            print(error.localizedDescription)
        }

        viewModel.loadLoquys()
    }
    
    private func handleNotification() {
        notificationShown = true
        message = LoquynClipText.loquySaved
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (value) in
            notificationShown = false
        }
    }
}
