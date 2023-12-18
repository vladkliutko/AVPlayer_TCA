//
//  PlaybackControlButtons.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import ComposableArchitecture

@Reducer
struct PlaybackControlButtons {

    struct State: Equatable {
        var isLoading: Bool = false
        var isPlaying: Bool = false
        var backwardEndIsEnabled: Bool = false
        var forwardEndIsEnabled: Bool = false
    }

    enum Action {
        case backwardEndButtonTapped
        case backwardButtonTapped
        case playbackSwitchChanged(_ isPlaying: Bool)
        case forwardButtonTapped
        case forwardEndButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .backwardEndButtonTapped:
                return .none
            case .backwardButtonTapped:
                return .none
            case .playbackSwitchChanged:
                return .none
            case .forwardButtonTapped:
                return .none
            case .forwardEndButtonTapped:
                return .none
            }
        }
    }
}
