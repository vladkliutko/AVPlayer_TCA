//
//  PlaybackTimelineControl.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import ComposableArchitecture
import Foundation

@Reducer
struct PlaybackTimelineControl {

    struct State: Equatable {
        var currentTimeInterval: TimeInterval = 0.0
        var maxTimeInterval: TimeInterval = 0.0
        var currentTimelineLabel: String = ""
        var maxTimelineLabel: String = ""
    }

    enum Action {
        case onAppear
        case timelineValueChanged(Double)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .timelineValueChanged:
                return .none
            }
        }
    }
}
