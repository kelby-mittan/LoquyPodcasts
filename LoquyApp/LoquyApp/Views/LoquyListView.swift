//
//  LoquyListView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct LoquyListView: View {
    
    let podcasts = DummyPodcast.podcasts
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
        //        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 10) {
                    ForEach(podcasts, id: \.self) { item in
                        VStack {
                            NavigationLink(destination: LoquyContentView()) {
                                ZStack {
                                    Color(#colorLiteral(red: 0.7904488444, green: 0.7596978545, blue: 1, alpha: 1))
                                        .offset(x: -6, y: -6)
                                        .blur(radius: 2)
                                        .cornerRadius(12)

                                    Image(item.image)
                                        .resizable()
                                        .frame(width: 170, height: 170)
                                        .padding(2)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                }.padding([.leading,.trailing],8)
            }
            .navigationBarTitle("Loquy List")
//            .navigationBarHidden(true)
        }
    }
}

struct LoquyListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            LoquyListView()
        } else {
            // Fallback on earlier versions
        }
    }
}


struct LoquyContentView: View {
    @State var toggled = false
    var buttonDimensions:CGFloat = 50
    
    let placeHolderText = "Ever wanted to know how music affects your brain, what quantum mechanics really is, or how black holes work? Do you wonder why you get emotional each time you see a certain movie, or how on earth video games are designed? Then you’ve come to the right place. Each week, Sean Carroll will host conversations with some of the most interesting thinkers in the world. From neuroscientists and engineers to authors and television producers, Sean and his guests talk about the biggest ideas in science, philosophy, culture and much more."
    
//    @State var isAtMaxScale = false
    
    var body: some View {
        
        VStack {
            
            if toggled {
                
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 12).padding().foregroundColor(PaletteColour.lightBlue.colour)//.opacity(0.5)

                    HStack {
                        Spacer()
                        Button(action: {
                                self.toggled = false
                            }) {
                                Image(systemName: "list.bullet.below.rectangle")
                                    .font(.system(size: 25))
                                    .foregroundColor(!toggled ? Color.white : Color.init(white: 0.8))
                        }
                        .frame(width: buttonDimensions, height:buttonDimensions)
                        .padding([.bottom,.trailing])
                    }
                    
                }
                .transition(
                    AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                )
                    .animation(Animation.interpolatingSpring(stiffness: 330, damping: 20.0, initialVelocity: 3.5))
            } else {
                ZStack {
//                    RoundedRectangle(cornerRadius: 12).padding().foregroundColor(PaletteColour.colors1.randomElement()).opacity(0.8)
                    VStack {
                        Spacer()
                        Text("Sean Carroll's Mindscape")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding([.leading,.trailing,.top,.bottom])
                        
                        Image("mindscape")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
//                            .scaleEffect(isAtMaxScale ? 1 : 1.15)
//                            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true))
//                            .onAppear() {
//                                isAtMaxScale.toggle()
//                            }
                        
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("You have 10 transcripts")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                    Text("from")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                        .padding(.top, 4)
                                    Text("6 saved audio clips")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                        .padding(.top, 4)
                                }
                                .padding([.bottom,.leading])
                                Spacer()
                            }
                            .padding(.leading, 20)
                            .padding([.trailing,.top])
//                            .background(CardNeoView(isRan: false))
//                            .cornerRadius(12)
                                                    
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                
                                self.toggled = true
                                
                            }) {
                                ZStack {
                                    NeoButtonView()
                                    Image(systemName: "text.quote").font(.largeTitle)
                                        .foregroundColor(.purple)
                                }.background(NeoButtonView())
                                .frame(width: 60, height: 60)
                                .clipShape(Capsule())
                                
                            }
                            .shadow(color: Color(#colorLiteral(red: 0.748958528, green: 0.7358155847, blue: 0.9863374829, alpha: 1)), radius: 8, x: 6, y: 6)
                            .shadow(color: Color(.white), radius: 10, x: -6, y: -6)
                        }
                    }.padding([.leading,.bottom,.trailing])
                    .background(CardNeoView(isRan: true))
                    .cornerRadius(12)
                }
                .padding([.leading,.trailing],12)
                .frame(height: UIScreen.main.bounds.height*2/3)
                .transition(
                    AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                        
                )
                .animation(Animation.interpolatingSpring(stiffness: 330, damping: 20.0, initialVelocity: 3.5))
            }
            
        }
//        .background(Color(.secondarySystemBackground))
        .navigationBarHidden(false)
        .navigationBarTitle("",displayMode: .inline)
    }
    
}
