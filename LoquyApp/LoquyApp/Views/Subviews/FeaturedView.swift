//
//  FeaturedView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct FeaturedView: View {
    
    var podcasts = DummyPodcast.podcasts[10...14]
    
    var body: some View {
        VStack {
            HeaderView(label: "Featured")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(podcasts, id: \.id) { pCast in
                        ZStack(alignment: .center) {
                            
                            NavigationLink(destination: EpisodesView(title: pCast.title, podcastFeed: pCast.feedUrl, isSaved: false)) {
                                
                                Image(pCast.image)
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: UIScreen.main.bounds.width - 80, height: 240)
                                    .cornerRadius(12)
                                
//                                Rectangle()
//                                    .foregroundColor(.black)
//                                    .opacity(0.0)
                            }
                        }
                                                
                    }
                    .padding([.leading,.trailing])
                }
            }
            .padding(.bottom)
        }
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
