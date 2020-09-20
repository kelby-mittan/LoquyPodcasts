//
//  DescriptionView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/7/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct DescriptionView: View {
    
    let episode: Episode
    
    var body: some View {
        VStack {
            
            HStack {
                Text(episode.title)
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.top,4)
                Spacer()
            }
            
//            HStack {
//                Text("Philosophy | Physics | Science")
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.leading)
//                    .padding(.top)
//                Spacer()
//            }
            
            HStack {
                Text(getOnlyDescription(episode.description))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top,4)
            
            
        }
        .padding([.leading,.trailing])
    }
    
    func getOnlyDescription(_ str: String) -> String {
        var word = str
        
        if let index = word.range(of: "\n\n")?.lowerBound {
            let substring = word[..<index]
            
            word = String(substring)
        }
        if let index2 = word.range(of: "<a ")?.lowerBound {
            let substring = word[..<index2]
            word = String(substring)
        }
        word = word.replacingOccurrences(of: "</p>", with: "\n\n")
        word = word.replacingOccurrences(of: "<p>", with: "")
        word = word.replacingOccurrences(of: "&nbsp", with: "")
        word = word.replacingOccurrences(of: "  ", with: "")
        
        return word
    }
}
