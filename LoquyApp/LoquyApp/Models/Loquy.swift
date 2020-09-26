//
//  Loquy.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/29/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct Loquy: Codable, Identifiable, Hashable {
    
    var id: UUID?
    let idInCollection: Int
    let title: String
    let transcription: String
    let audioClip: AudioClip
    
//    static let loquies = [Loquy(title: "Origins Takeaway", transcription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit dignissim urna eu vulputate. Sed tempus, erat vel sollicitudin facilisis, ipsum nisl semper orci, vel aliquam massa nulla sit amet magna. Etiam pulvinar vulputate lectus nec eleifend. Quisque vitae vehicula felis. Praesent in ullamcorper enim, vitae suscipit ipsum. Praesent turpis lectus, dictum sit amet scelerisque id, blandit in est. Vestibulum tincidunt dui vel ex ullamcorper consectetur", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: ""),Loquy(title: "Mindset Takeaway", transcription: "Duis lacinia arcu felis, ac egestas mi suscipit at. Fusce dignissim ante magna, vel hendrerit massa lacinia nec. Morbi cursus bibendum eleifend. In posuere ullamcorper maximus. Morbi placerat pharetra magna eu auctor. Aliquam id luctus leo. Nulla luctus sit amet purus vel pharetra", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: ""),Loquy(title: "Portal insight", transcription: "Praesent porta condimentum leo, non maximus nisi luctus in. Ut auctor sem lacus, vitae fringilla justo volutpat ut. Nulla luctus tincidunt est, id pellentesque mauris commodo ac. Quisque aliquam turpis et tincidunt rhoncus", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: ""),Loquy(title: "Sean Carroll", transcription: "Donec at risus sit amet nisl cursus placerat et quis leo. Praesent sit amet placerat massa. Nam mollis, justo in rhoncus ornare, arcu turpis consequat mauris, et malesuada leo massa nec eros.", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: ""),Loquy(title: "Rogan talks about something", transcription: "Morbi egestas purus nec metus tincidunt commodo. Pellentesque est nisl, ultricies id ipsum id, iaculis imperdiet leo. Vivamus gravida volutpat tortor id hendrerit. Sed laoreet elit sit amet accumsan cursus. Integer consequat dignissim interdum. Mauris eget justo blandit, dignissim tortor non, dapibus justo. Suspendisse sagittis enim ac est auctor rhoncus. ", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: ""),Loquy(title: "Lex talks about robots", transcription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit dignissim urna eu vulputate. Sed tempus, erat vel sollicitudin facilisis, ipsum nisl semper orci, vel aliquam massa nulla sit amet magna. Etiam pulvinar vulputate lectus nec eleifend. Quisque vitae vehicula felis. Praesent in ullamcorper enim, vitae suscipit ipsum. Praesent turpis lectus, dictum sit amet scelerisque id, blandit in est. Vestibulum tincidunt dui vel ex ullamcorper consectetur", imageUrl: "origins", feedUrl: "https://originspodcast.libsyn.com/rss", timeStamp: "")]
}
