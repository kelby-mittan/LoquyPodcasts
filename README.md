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
_Browse_ | _Player_ | _Save Clip_
------------ | ------------- | -------------
![gif](Assets/loquyGif1.gif) | ![gif](Assets/loquyGif2.gif) | ![gif](Assets/loquyGif3.gif)
_Transcribe_ | _Saved Transcriptions_ | _Time_Stamps_
![gif](Assets/loquyGif4.gif) | ![gif](Assets/loquyGif5.gif)

## Code Snippets

### Using SFSpeechRecognizer to transcribe audio from a clip
```swift
private func getTranscriptionOfClippedFile() {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let url = AudioTrim.loadUrlFromDiskWith(fileName: audioClip.episode.title + audioClip.startTime + ".m4a") {
                
                AudioTrim.trimUsingComposition(url: url, start: currentTime, duration: audioClip.duration, pathForFile: "trimmedFile") { (result) in
                    switch result {
                    case .success(let clipUrl):
                        print(clipUrl)

                        let request = SFSpeechURLRecognitionRequest(url: clipUrl)

                        speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                            if let theError = error {
                                print("recognition error: \(theError)")
                            } else {
                                
                                if playing {
                                    transcription = result?.bestTranscription.formattedString ?? "could not get treanscription"
                                }
                            }
                        })
                    default:
                        print("problem getting clip")
                    }
                }

            }
        }
    }
 ```

### Building a Neumorphic Play/Pause Button view with SwiftUI
```swift

struct NeoButtonView: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8638685346, green: 0.8565297723, blue: 1, alpha: 1))
            
            Capsule()
                .foregroundColor(.white)
                .blur(radius: 4)
                .offset(x: -8, y: -8)
            Capsule()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9536944032, green: 0.9129546285, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(2)
                .blur(radius: 2)
        }
    }
}

Button(action: {
    playing.toggle()
    playing ? player.play() : player.pause()

}) {
    ZStack {
        NeoButtonView()
        Image(systemName: playing ? "pause.fill" : "play.fill").font(.largeTitle)
            .foregroundColor(.purple)
    }.background(NeoButtonView())
    .frame(width: 80, height: 80)
    .clipShape(Capsule())
    .animation(.spring())
}
```
