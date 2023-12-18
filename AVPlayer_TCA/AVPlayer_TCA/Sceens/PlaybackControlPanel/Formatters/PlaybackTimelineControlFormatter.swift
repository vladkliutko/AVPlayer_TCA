//
//  PlaybackTimelineControlFormatter.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct PlaybackTimelineControlFormatter {

    func formatSpeedRate(_ rate: Float) -> String {
        return String(format: "%g", rate) + "x speed"
    }
    
    func formatTimeIntervalToTime(_ interval: TimeInterval) -> String {
        return interval.formattedTime()
    }

    func formatKeyPoint(current: Int, total: Int) -> String {
        return "key point \(current) of \(total)"
    }
}

extension PlaybackTimelineControlFormatter: DependencyKey {
    static var liveValue: Self {
        return PlaybackTimelineControlFormatter()
    }
}

extension DependencyValues {
    var playbackTimelineControlFormatter: PlaybackTimelineControlFormatter {
        get { self[PlaybackTimelineControlFormatter.self] }
        set { self[PlaybackTimelineControlFormatter.self] = newValue }
    }
}
