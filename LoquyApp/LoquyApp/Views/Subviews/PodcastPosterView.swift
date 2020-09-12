//
//  PodcastPosterView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 9/12/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct PodcastPosterView: View {
    let podcast: DummyPodcast
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(podcast.image)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .cornerRadius(12)
            .padding()
    }
}

struct PodcastPosterView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastPosterView(podcast: DummyPodcast.origins, width: 200, height: 200)
    }
}
