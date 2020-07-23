//
//  TopPodcastsView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct PodcastScrollView: View {
    
    var pCasts = DummyPodcast.podcasts
    
    var body: some View {
        VStack {
            HeaderView(label: "Top Podcasts")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< 5) { item in
                        TopPodcastsView()
                    }
                }
            }
        }
    }
}

struct TopPodcastsView: View {
    
    var pCasts = DummyPodcast.podcasts[0...1]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(pCasts, id: \.id) { pcast in
                NavigationLink(destination: Text("Coming Soon")) {
                    
                    HStack(alignment: .top) {
                        Image(pcast.image)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 72, height: 72)
                            .background(Color.purple)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(pcast.title)
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding(.bottom, 4)
                            Text(pcast.host)
                                .foregroundColor(Color(.label))
                                .font(.subheadline)
                                .fontWeight(.light)
                                .padding(.bottom, 4)
                            
                            
                            HStack {
                                Text(pcast.category)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .padding(.bottom, 4)
                                Spacer()
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: 100, height: 8)
                                        .foregroundColor(Color(.systemGray4))
                                    
                                    Rectangle()
                                        .frame(width: 40, height: 8)
                                        .foregroundColor(Color(.orange))
                                }
                                .clipShape(Capsule())
                            }
                            
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
}
