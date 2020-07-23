//
//  LabelViews.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct PCastHeaderLabelView: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(Color.white)
    }
}

struct PCastBodyLabelView: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .foregroundColor(Color(.systemGray5))
    }
}

struct HeaderView: View {
    
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.title)
                .fontWeight(.heavy)
            Spacer()
        }
        .padding(.leading)
    }
}
