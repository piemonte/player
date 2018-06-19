//  ViewController.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

let videoUrl = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!

class ViewController: UIViewController {
    internal var player = Player()

    // MARK: object lifecycle

    deinit {
        player.willMove(toParentViewController: self)
        player.view.removeFromSuperview()
        player.removeFromParentViewController()
    }

    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.autoresizingMask = ([.flexibleWidth, .flexibleHeight])

        player.playerDelegate = self
        player.playbackDelegate = self
        player.view.frame = view.bounds

        addChildViewController(player)
        view.addSubview(player.view)
        player.didMove(toParentViewController: self)

        player.url = videoUrl

        player.playbackLoops = true

        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        player.playFromBeginning()
    }
}

// MARK: - UIGestureRecognizer

extension ViewController {
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch player.playbackState.rawValue {
        case PlaybackState.stopped.rawValue:
            player.playFromBeginning()
        case PlaybackState.paused.rawValue:
            player.playFromCurrentTime()
        case PlaybackState.playing.rawValue:
            player.pause()
        case PlaybackState.failed.rawValue:
            player.pause()
        default:
            player.pause()
        }
    }
}

// MARK: - PlayerDelegate

extension ViewController: PlayerDelegate {
    func playerReady(player: Player) {}

    func playerPlaybackStateDidChange(player: Player) {}

    func playerBufferingStateDidChange(player: Player) {}

    func playerBufferTimeDidChange(bufferTime: Double) {}
}

// MARK: - PlayerPlaybackDelegate

extension ViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(player: Player) {}

    func playerPlaybackWillStartFromBeginning(player: Player) {}

    func playerPlaybackDidEnd(player: Player) {}

    func playerPlaybackWillLoop(player: Player) {}
}
