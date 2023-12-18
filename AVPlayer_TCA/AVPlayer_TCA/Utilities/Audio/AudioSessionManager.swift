//
//  AudioSessionManager.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 17.12.2023.
//

import AVFoundation

enum AudioSessionManagerError: Error {
    case audioSessionSetupFailed
    case audioSessionActivationFailed
}

protocol AudioSessionManagerProtocol {
    func setupAndActivateSession() throws
    func deactivateSession() throws
}

/// - TODO: Should be configured in the appropriate place in the application
/// - Discussion:  `AVAudioSession` can be configured for the entire application lifecycle.
final class AudioSessionManager: AudioSessionManagerProtocol {
    private let session: AVAudioSession

    init(session: AVAudioSession = .sharedInstance()) {
        self.session = session
    }

    func setupAndActivateSession() throws {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: [.allowAirPlay, .allowBluetooth, .duckOthers]
            )
            try session.setActive(true)
            try session.overrideOutputAudioPort(.speaker)
        } catch {
            throw AudioSessionManagerError.audioSessionSetupFailed
        }
    }

    func deactivateSession() throws {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            throw AudioSessionManagerError.audioSessionActivationFailed
        }
    }
}
