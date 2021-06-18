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
                Image(Assets.mindscape)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 150, height: 150, alignment: .center)
                    .cornerRadius(8)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 160, y: 0)
                    .background(Color.clear)
                
                VStack(alignment: .leading) {
                    
                    PCastHeaderLabelView(label: HomeText.weThink)
                        .offset(x: -10, y: 0)
                    
                    PCastHeaderLabelView(label: HomeText.youllLike)
                        .offset(x: -10, y: 0)
                    PCastBodyLabelView(label: HomeText.mindscape)
                        .offset(x: -10, y: 0)
                    PCastBodyLabelView(label: HomeText.sCarrol)
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
