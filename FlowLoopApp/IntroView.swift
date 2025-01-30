//
//  Startup.swift
//  FlowLoop
//
//  Created by Viesturs Kaugers  on 21/12/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct IntroView: View {
    @ObservedObject var videoItem: VideoItem = VideoItem()
    var videoURL = Bundle.main.url(forResource: "intro", withExtension: "m4v")!

    var body: some View {
        VStack {
            if videoItem.playerItem != nil {
                PlayerView(player: $videoItem.player)
            }
        }.frame(minWidth: 1141, maxWidth: 1141, minHeight: 442, maxHeight: 442)
    }
    
    func stop() {
        self.videoItem.player.pause()
    }

    func start() {
        self.videoItem.open(videoURL)
        self.videoItem.player.play()
    }
}

struct PlayerView: NSViewRepresentable {
    @Binding var player: AVPlayer

    func updateNSView(_ NSView: NSView, context: NSViewRepresentableContext<PlayerView>) {
        guard let view = NSView as? AVPlayerView else {
            debugPrint("unexpected view")
            return
        }

        view.player = player
    }

    func makeNSView(context: Context) -> NSView {
        return AVPlayerView(frame: .zero)
    }
}

class VideoItem: ObservableObject {
    @Published var player: AVPlayer = AVPlayer()
    @Published var playerItem: AVPlayerItem?

    func open(_ url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.playerItem = playerItem
        player.replaceCurrentItem(with: playerItem)
    }
}
