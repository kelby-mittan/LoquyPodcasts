//
//  DummyPodcast.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct DummyPodcast: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let host: String
    let category: String
    let image: String
    let description: String
    let guest: String
    let rating: String
    let feedUrl: String
    
    static let origins = DummyPodcast(title: "Origins", host: "Lawrence Krauss",  category: "Science", image: "origins", description: "The Origins Podcast features in-depth conversations with some of the most interesting people in the world about the issues that impact all of us in the 21st century. Host, theoretical physicist, lecturer, and author, Lawrence M. Krauss, will be joined by guests from a wide range of fields, including science, the arts, and journalism. The topics discussed on The Origins Podcast reflect the full range of the human experience – exploring science and culture in a way that seeks to entertain, educate, and inspire.", guest: "Noam Chomsky", rating: "3.5", feedUrl: "https://originspodcast.libsyn.com/rss")
    
    static let podcasts = [DummyPodcast(title: "Origins", host: "Lawrence Krauss",  category: "Science", image: "origins", description: "The Origins Podcast features in-depth conversations with some of the most interesting people in the world about the issues that impact all of us in the 21st century. Host, theoretical physicist, lecturer, and author, Lawrence M. Krauss, will be joined by guests from a wide range of fields, including science, the arts, and journalism. The topics discussed on The Origins Podcast reflect the full range of the human experience – exploring science and culture in a way that seeks to entertain, educate, and inspire.", guest: "Noam Chomsky", rating: "4.0", feedUrl: "https://originspodcast.libsyn.com/rss"),DummyPodcast(title: "Star Talk", host: "Neil DeGrasse Tyson", category: "Science", image: "starTalk", description: "StarTalk is a podcast on space, science, and popular culture hosted by astrophysicist Neil deGrasse Tyson, with various comic and celebrity co-hosts and frequent guests from the worlds of science and entertainment", guest: "Chuck Nice", rating: "4.0", feedUrl: "https://www.omnycontent.com/d/playlist/aaea4e69-af51-495e-afc9-a9760146922b/43816ad6-9ef9-4bd5-9694-aadc001411b2/808b901f-5d31-4eb8-91a6-aadc001411c0/podcast.rss"),DummyPodcast(title: "Yang Speaks", host: "Andrew Yang", category: "Politics", image: "yangSpeaks", description: "The weekly show will broadly cover the future of the U.S. economy and society, according to the show’s producers. It will feature in-depth discussions with “thought-leaders” on a range of topics including tech, public policy, sports, entertainment and pop culture — and, presumably, anything else that is on Yang’s mind. The series launch is slated for May 2020.", guest: "Eric Weinstein", rating: "3.5", feedUrl: "https://feeds.megaphone.fm/yang-speaks"),DummyPodcast(title: "Artificial Intelligence", host: "Lex Fridman", category: "Tech", image: "lfAI", description: "The Artificial Intelligence (AI) podcast hosts accessible, big-picture conversations at MIT and beyond about the nature of intelligence with some of the most interesting people in the world thinking about AI from the perspective of deep learning, robotics, AGI, neuroscience, philosophy, psychology, cognitive science, economics, physics, mathematics, and more.", guest: "Elon Musk", rating: "3.0", feedUrl: "https://lexfridman.com/feed/podcast/"),DummyPodcast(title: "Making Sense", host: "Sam Harris", category: "Philosophy", image: "makingSense", description: "In this episode of the podcast, Sam Harris speaks with Robert Plomin about the role that DNA plays in determining who we are. They discuss the birth of behavioral genetics, the taboo around studying the influence of genes on human psychology, controversies surrounding the topic of group differences, the first law of behavior genetics, heritability, nature and nurture, the mystery of unshared environment, the way genes help determine a person’s environment, epigenetics, the genetics of complex traits, dimensions vs disorders, the prospect of a GATTACA-like dystopia and genetic castes, heritability and equality of opportunity, the implications of genetics for parenting and education, DNA as a fortune-telling device, and other topics.", guest: "Robert Plomin", rating: "4.0", feedUrl: "https://wakingup.libsyn.com/rss"), DummyPodcast(title: "Joe Rogan", host: "Joe Rogan", category: "All", image: "rogan", description: "The Joe Rogan Experience is a free audio and video podcast hosted by American comedian, actor, sports commentator, martial artist, and television host, Joe Rogan. It was launched on December 24, 2009, by Rogan and comedian Brian Redban, who also produced and co-hosted. ", guest: "Graham Hancock", rating: "4.0", feedUrl: "http://joeroganexp.joerogan.libsynpro.com/rss"),DummyPodcast(title: "Mindspace", host: "Sean Carrol", category: "Physics", image: "mindscape", description: "Ever wanted to know how music affects your brain, what quantum mechanics really is, or how black holes work? Do you wonder why you get emotional each time you see a certain movie, or how on earth video games are designed? Then you’ve come to the right place. Each week, Sean Carroll will host conversations with some of the most interesting thinkers in the world. From neuroscientists and engineers to authors and television producers, Sean and his guests talk about the biggest ideas in science, philosophy, culture and much more.", guest: "Scott Miles", rating: "4.0", feedUrl: "https://rss.art19.com/sean-carrolls-mindscape"),DummyPodcast(title: "The Daily", host: "The New York Times",  category: "News", image: "theDaily", description: "The Daily is a daily news podcast and radio show by the American newspaper The New York Times. Hosted by Times political journalist Michael Barbaro, its episodes are based on the Times' reporting of the day with interviews of journalists from the New York Times", guest: "John Lewis", rating: "4.0", feedUrl: "http://rss.art19.com/the-daily"),DummyPodcast(title: "The Portal", host: "Eric Weinstein", category: "Mathematics", image: "thePortal", description: "", guest: "Bret Weinstein", rating: "4.5", feedUrl: "https://rss.art19.com/the-portal"),DummyPodcast(title: "WTF", host: "Marc Maron", category: "Comedy", image: "wtf", description: "", guest: "Dave Chapelle", rating: "3.5", feedUrl: "https://www.omnycontent.com/d/playlist/aaea4e69-af51-495e-afc9-a9760146922b/8a755b22-8f72-4d44-8ff9-ab79013fda25/6b8a5068-9bea-439f-bd4d-ab79013fda2b/podcast.rss"),DummyPodcast(title: "Up First", host: "NPR", category: "Literature", image: "npr", description: "The Artificial Intelligence (AI) podcast hosts accessible, big-picture conversations at MIT and beyond about the nature of intelligence with some of the most interesting people in the world thinking about AI from the perspective of deep learning, robotics, AGI, neuroscience, philosophy, psychology, cognitive science, economics, physics, mathematics, and more.", guest: "Howard Stern", rating: "3.0", feedUrl: "https://feeds.npr.org/510318/podcast.xml"),DummyPodcast(title: "Swift by Sundell", host: "John Sundell", category: "Tech", image: "swiftSundell", description: "", guest: "Alex Paul", rating: "4.5", feedUrl: "https://swiftbysundell.com/podcast/feed.rss"), DummyPodcast(title: "Rebel Wisdom", host: "Tristan Harris", category: "Philosophy", image: "rebel", description: "", guest: "Sam Harris", rating: "4.0", feedUrl: "https://rebelwisdom.podbean.com/feed.xml"),DummyPodcast(title: "Reset", host: "VOX", category: "Philosophy", image: "reset", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "https://feeds.megaphone.fm/VMP9176219298"),DummyPodcast(title: "The Wright Show", host: "Robert Wright", category: "Philosophy", image: "wrightShow", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "http://wrightshow.com/feed?format=audio"),DummyPodcast(title: "Smartless", host: "Jason Bateman", category: "Comedy", image: "smartless", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "https://feeds.simplecast.com/pvzhyDQn"),DummyPodcast(title: "The Daily Show", host: "Trevor Noah", category: "Comedy", image: "noah", description: "", guest: "", rating: "4.0", feedUrl: "https://feeds.megaphone.fm/the-daily-show"),DummyPodcast(title: "KFC Radio", host: "Dave Portnoy", category: "Sports", image: "kfcRadio", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "https://mcsorleys.barstoolsports.com/feed/kfc-radio"),DummyPodcast(title: "Stuff You Should Know", host: "", category: "Science", image: "youShouldKnow", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "https://feeds.megaphone.fm/stuffyoushouldknow"),DummyPodcast(title: "Science Salon", host: "Michael Schermer", category: "Science", image: "scienceSalon", description: "", guest: "", rating: "4.0", feedUrl: "https://sciencesalon.libsyn.com/rss"),DummyPodcast(title: "Common Sense", host: "Dan Carlin", category: "Politics", image: "commonSense", description: "", guest: "", rating: "4.0", feedUrl: "http://feeds.feedburner.com/dancarlin/commonsense?format=xml"),DummyPodcast(title: "The Jimmy Dore Show", host: "Jimmy Dore", category: "Politics", image: "jimmyDore", description: "", guest: "Dylan Ratigan", rating: "4.0", feedUrl: "https://thejimmydoreshow.libsyn.com/rss"),DummyPodcast(title: "Dark Horse Podcast", host: "", category: "Science", image: "darkHorse", description: "", guest: "Scott Miles", rating: "4.0", feedUrl: "https://feeds.buzzsprout.com/424075.rss")]
    
    static var eps = [Episode]()
}
