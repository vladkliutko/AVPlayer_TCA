//
//  AudioPlayerProvider.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 17.12.2023.
//

import AVFoundation
import Combine
import ComposableArchitecture

protocol AudioPlayerProviderProtocol {
    var currentItemDurationPublisher: PassthroughSubject<TimeInterval, Never> { get }
    var currentTimeIntervalPublisher: PassthroughSubject<TimeInterval, Never> { get }

    func setCurrentItemURL(_ itemURL: URL)
    func play()
    func pause()
    func seek(to seconds: TimeInterval)
    func forward(seconds: TimeInterval)
    func backward(seconds: TimeInterval)
    func setPlaybackRate(_ rate: Float)
}

/// Solution based on the AVPlayer.
/// - Discussion: Would be better to looked at a more "composable" solution like https://github.com/tokopedia/ios-superplayer
final class AudioPlayerProvider {

    private var player: AVPlayer

    private var derationCancellable: Any?
    private var timeCancellable: Any?

    let currentTimeIntervalPublisher = PassthroughSubject<TimeInterval, Never>()
    let currentItemDurationPublisher = PassthroughSubject<TimeInterval, Never>()

    init(player: AVPlayer = AVPlayer()) {
        self.player = player
    }

    deinit {
        derationCancellable = nil
        timeCancellable = nil
    }
}

// MARK: - AudioPlayerProtocol

extension AudioPlayerProvider: AudioPlayerProviderProtocol {

    func setCurrentItemURL(_ itemURL: URL) {
        let item = AVPlayerItem(url: itemURL)
        player.replaceCurrentItem(with: item)

        setDurationObserver()
        setPeriodicTimeObserver()
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func seek(to seconds: TimeInterval) {
        let newTime = CMTime(seconds: seconds, preferredTimescale: 1)
        player.seek(to: newTime)
    }

    func forward(seconds: TimeInterval) {
        guard let currentTime = player.currentItem?.currentTime() else { return }

        let newTime = CMTimeAdd(currentTime, CMTime(seconds: seconds, preferredTimescale: 1))
        player.seek(to: newTime)
    }

    func backward(seconds: TimeInterval) {
        guard let currentTime = player.currentItem?.currentTime() else { return }

        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: seconds, preferredTimescale: 1))
        player.seek(to: newTime)
    }

    /// - Note: The method updates current item audio time pitch algorithm to `.varispeed`.
    func setPlaybackRate(_ rate: Float) {
        player.currentItem?.audioTimePitchAlgorithm = .varispeed
        player.rate = rate
    }
}

// MARK: - Private

private extension AudioPlayerProvider {

    // MARK: Time observation

    func setDurationObserver() {
        derationCancellable = player.currentItem?.observe(\AVPlayerItem.status) { [weak self] item, _ in
            guard let self = self else { return }
            // Prevent reading duration from an outdated item
            guard item == self.player.currentItem else { return }

            if item.status == .readyToPlay {
                currentItemDurationPublisher.send(item.duration.seconds)
            }
        }
    }

    /// Sends the current time once per second
    func setPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeCancellable = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }

            if let currentItem = player.currentItem, currentItem.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(player.currentTime())

                currentTimeIntervalPublisher.send(TimeInterval(currentTime))
            }
        }
    }
}
