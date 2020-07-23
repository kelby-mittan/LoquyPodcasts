//
//  FeaturedView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct FeaturedView: View {
    
    var pCasts = DummyPodcast.podcasts[2...6]
    
    var body: some View {
        VStack {
            HeaderView(label: "Featured")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(pCasts, id: \.id) { pCast in
                        ZStack(alignment: .center) {
                            
                            NavigationLink(destination: Text("Coming Soon")) {
                                
                                Image(pCast.image)
                                    .resizable()
                                    .renderingMode(.original)
                                    .cornerRadius(12)
                                    .frame(width: UIScreen.main.bounds.width - 80, height: 230)
                                
//                                Rectangle()
//                                    .foregroundColor(.black)
//                                    .opacity(0.0)
                            }
                        }
                                                
                    }
                    .padding(.leading)
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
