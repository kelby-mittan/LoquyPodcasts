//
//  SaveLoquyAlertView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI
import Combine

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
    @State var dominantColor: UIColor?
    @State var keyboardHeight: CGFloat = 0
    
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
                        .foregroundColor(Color(dominantColor ?? .lightGray))
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
                            .foregroundColor(Color(dominantColor ?? .lightGray))
                            .background(NeoButtonView(dominantColor: $dominantColor))
                            .clipShape(Capsule())
                            .padding()
                    }
                
                Spacer()
            }
            
        }
        .frame(width: 300, height: 200)
        .background(Color(dominantColor ?? .clear))
        .cornerRadius(20)
        .offset(y: -keyboardHeight / 4)
        .animation(.easeInOut, value: keyboardHeight)
        .onAppear {
            viewModel.loadLoquys()
            viewModel.getDominantColor(audioClip.episode.imageUrl ?? RepText.empty) { clr in
                dominantColor = clr
            }
        }
        .onReceive(Publishers.keyboardHeight) { height in
            keyboardHeight = height
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
