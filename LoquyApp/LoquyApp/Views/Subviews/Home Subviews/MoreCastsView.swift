//
//  MoreCastsView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/23/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct MoreCastsView: View {
    
    var podcasts = DummyPodcast.podcasts
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                GridItemView(cast1: podcasts[15], cast2: podcasts[16])
                GridItemView(cast1: podcasts[17], cast2: podcasts[18])
                GridItemView(cast1: podcasts[19], cast2: podcasts[20])
                GridItemView(cast1: podcasts[21], cast2: podcasts[22])
            }
            .padding()
        }
    }
}

struct GridItemView: View {
    
    var cast1: DummyPodcast
    var cast2: DummyPodcast
    
    var body: some View {
        HStack {
            
            NavigationLink(destination: EpisodesView(title: cast1.title, podcastFeed: cast1.feedUrl, isSaved: false, artWork: cast1.image)) {
                
                VStack {
                    Text(cast1.category)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .underline()
                        .foregroundColor(Color(.systemGray2))
                    Image(cast1.image)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 160, height: 160)
                        .cornerRadius(8)
                        .padding(.bottom)
                }
                
            }
            
            Spacer()
            
            NavigationLink(destination: EpisodesView(title: cast2.title, podcastFeed: cast2.feedUrl, isSaved: false, artWork: cast2.image)) {
                VStack {
                    Text(cast2.category)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .underline()
                        .foregroundColor(Color(.systemGray2))
                    Image(cast2.image)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 160, height: 160)
                        .cornerRadius(8)
                        .padding(.bottom)
                }
            }
        }
    }
}
