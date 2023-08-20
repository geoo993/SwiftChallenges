import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State var player = AVPlayer()
    @State var videoStartTime: CMTime = CMTimeMake(value: 40, timescale: 1)
    private var videoUrl = URL(string: "https://www.dropbox.com/scl/fi/k0ifparecj27646btfm5o/Jessie-J-Price-Tag-ft.-B.o.B.mp4?rlkey=yl5xviwdug8kaai6f5a1o927s&raw=1")

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onAppear {
                if let url = videoUrl {
                    player = AVPlayer(url: url)
//                    player.play()
//                    player.seek(to: videoStartTime)
//                    player.rate = 1.1
//                    let currentTime = player.currentTime()
//                    print("current time", CMTimeGetSeconds(currentTime))
                }
            }
    }
}

#Preview {
    VideoPlayerView()
}
