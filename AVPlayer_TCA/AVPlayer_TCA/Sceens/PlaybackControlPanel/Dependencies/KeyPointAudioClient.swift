//
//  KeyPointAudioClient.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 17.12.2023.
//

import Foundation
import ComposableArchitecture
import Combine

@DependencyClient
struct KeyPointAudioClient {
    private let player: AudioPlayerProviderProtocol
    private let sessionManager: AudioSessionManagerProtocol
    private let items: [URL]

    init(
        player: AudioPlayerProviderProtocol = AudioPlayerProvider(),
        sessionManager: AudioSessionManagerProtocol = AudioSessionManager(),
        items: [URL]
    ) {
        self.player = player
        self.sessionManager = sessionManager
        self.items = items

        try? sessionManager.setupAndActivateSession()
    }

    /// Sends the current playback time. Updated once per second
    var currentTimeIntervalPublisher: PassthroughSubject<TimeInterval, Never> {
        return player.currentTimeIntervalPublisher
    }

    /// Updated as soon as it receives the duration of the current item
    var currentItemDurationPublisher: PassthroughSubject<TimeInterval, Never> {
        return player.currentItemDurationPublisher
    }

    func setCurrentItemURL(_ itemURL: URL) {
        player.setCurrentItemURL(itemURL)
    }

    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }

    func seek(to seconds: TimeInterval) {
        player.seek(to: seconds)
    }

    func forward(seconds: TimeInterval) {
        player.forward(seconds: seconds)
    }

    func backward(seconds: TimeInterval) {
        player.backward(seconds: seconds)
    }

    /// - Note: The method updates current item audio time pitch algorithm to `.varispeed`.
    func setPlaybackRate(_ rate: Float) {
        player.setPlaybackRate(rate)
    }
}

extension KeyPointAudioClient: DependencyKey {
    static var liveValue: Self {
        return KeyPointAudioClient(items: [])
    }
}

extension DependencyValues {
    var keyPointAudioClient: KeyPointAudioClient {
        get { self[KeyPointAudioClient.self] }
        set { self[KeyPointAudioClient.self] = newValue }
    }
}
