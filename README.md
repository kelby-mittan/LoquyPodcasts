# Loquy Podcasts 

## About
Loquy is a podcast application that allows for users to browse, search, and play their favorite podcasts. By calling on the Apple Music API, a user can find any podcast on Apple. This application was built and designed using SwiftUI, parses XML, and uses MediaPlayer to play podcasts

### Future Implementations
- Play podcast in the background
- Favorite and download podcasts
- Save and transcribe audio clips

## Technologies Used
Xcode 11, Swift 5, SwiftUI ,MediaPlayer, AVFoundation, Combine, CocoaPods

## Screen Shots
![Loquy](Assets/homeTab.png)![Loquy](Assets/playingPodcast.png)![Loquy](Assets/clipView.png)![Loquy](Assets/transcribeView.png)
![Loquy](Assets/savedTView.png)![Loquy](Assets/pageView.png)

## User Experience
_Browse_ | _Player_ | _Time_Stamps_
------------ | ------------- | -------------
![gif](Assets/loquyGif1.gif) | ![gif](Assets/loquyGif2.gif) | ![gif](Assets/loquyGif3.gif)

## Code Snippets

### Building a detail view with SwiftUI
```swift
struct EpisodeDetailView: View {
    
    let episode: Episode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            RemoteImage(url: episode.imageUrl ?? "")
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding()
            
            ControlView(episode: episode)
            DescriptionView(episode: episode)
            FavoriteView()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
```
