//
//  TopPodcastsView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct PodcastScrollView: View {
    
    private let podcasts = DummyPodcast.podcasts
    
    var body: some View {
        VStack {
            HeaderView(label: HomeText.topCasts)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    TopPodcastsView(podcasts: self.podcasts[0...1])
                    TopPodcastsView(podcasts: self.podcasts[2...3])
                    TopPodcastsView(podcasts: self.podcasts[4...5])
                    TopPodcastsView(podcasts: self.podcasts[6...7])
                    TopPodcastsView(podcasts: self.podcasts[8...9])
                }
            }
        }
    }
}

struct TopPodcastsView: View {
    
    public var podcasts: Array<DummyPodcast>.SubSequence
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(podcasts, id: \.id) { pcast in
                NavigationLink(destination: EpisodesView(title: pcast.title,
                                                         podcastFeed: pcast.feedUrl,
                                                         isSaved: false,
                                                         artWork: pcast.image)) {
                    
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
                                .foregroundColor(Color(.label))
                                .font(.headline)
                                .padding(.top, 4)
                            Text(pcast.host)
                                .foregroundColor(Color(.label))
                                .font(.subheadline)
                                .fontWeight(.light)
                                .padding(.bottom, 0)
                            HStack {
                                Text(pcast.category)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .padding(.bottom, 0)
                                Spacer()
                                
                            }
                            
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
}
