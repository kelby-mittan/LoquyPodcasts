//
//  ListenToView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct ListenToView: View {
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                Image("mindscape")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 150, height: 150, alignment: .center)
                    .cornerRadius(8)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 160, y: 0)
                    .background(Color.clear)
                
                VStack(alignment: .leading) {
                    
                    PCastHeaderLabelView(label: "We Think")
                        .offset(x: -10, y: 0)
                    
                    PCastHeaderLabelView(label: "You'll Like")
                        .offset(x: -10, y: 0)
                    PCastBodyLabelView(label: "Mindscape")
                        .offset(x: -10, y: 0)
                    PCastBodyLabelView(label: "Sean Carroll")
                    .offset(x: -10, y: 0)
                }
                
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .center)
        .background(CardNeoView(isRan: true))
        .cornerRadius(14)
        
    }
}
