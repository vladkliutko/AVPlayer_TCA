//
//  BookKeyPoints.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import ComposableArchitecture
import Combine
import Foundation

@Reducer
struct BookKeyPoints {

    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?

        enum Mode: Equatable {
            case loading, presenting
        }

        var bookIdentifier = ""
        var mode: Mode = .loading
        var keyPointText = ""
        var keyPointDescriptionText = ""
        var currentSpeedRateText = ""
        var bookInfo: BookInfo.State
        var timelineState: PlaybackTimelineControl.State
        var playbackControlButtonsState: PlaybackControlButtons.State
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        enum Alert {
            case crashApp
        }

        case onAppear
        case updateMode(State.Mode)
        case bookResponse(Result<BookInfoModel, Error>)
        case keyPointDidUpdate
        case rateButtonDidTap
        case audioItemDurationDidUpdate(duration: TimeInterval)
        case updateCurrentTime(currentTime: TimeInterval)

        case timelineAction(PlaybackTimelineControl.Action)
        case playbackControlButtonsAction(PlaybackControlButtons.Action)
        case bookInfoAction(BookInfo.Action)
    }

    @Dependency(\.speedRateProvider) var rateProvier
    @Dependency(\.playbackTimelineControlFormatter) var formatter
    @Dependency(\.keyPointAudioClient) var audioClient
    @Dependency(\.bookClient) var bookClient

    var body: some Reducer<State, Action> {
        Scope(state: \.bookInfo, action: \.bookInfoAction) {
          BookInfo()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.playbackControlButtonsState.isLoading = state.mode == .loading
                return .send(.updateMode(.loading)).concatenate(
                    with: .run { [bookId = state.bookIdentifier] send in
                        await send(.bookResponse(Result { try await self.bookClient.bookData(bookIdentifier: bookId) }))
                    }
                )

            case .updateMode(let mode):
                state.mode = mode
                state.playbackControlButtonsState.isLoading = state.mode == .loading
                return .none

            case .bookResponse(.success(let bookInfoModel)):
                state.bookInfo.bookCoverURL = bookInfoModel.bookCoverURL
                state.bookInfo.keyPoints = bookInfoModel.keyPoints

                // TODO: Should be handled somehow
                guard let currentKeyPointAudioURL = state.bookInfo.currentKeyPoint?.audioURL else { return .none }

                audioClient.setCurrentItemURL(currentKeyPointAudioURL)

                return .send(.keyPointDidUpdate).concatenate(
                    with: .publisher {
                        audioClient.currentItemDurationPublisher.map { .audioItemDurationDidUpdate(duration: $0) }
                    }
                )

            case .bookResponse(.failure(let error)):
                print("Error: \(error.localizedDescription)")

                state.alert = AlertState {
                    TextState("Cannot display the book")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("See non-prepared UI")
                    }
                    ButtonState(role: .destructive, action: .send(.crashApp)) {
                        TextState("Crash the app!")
                    }
                } message: {
                    TextState("What luck! I would recommend checking the BookClient and reloading the app. See you")
                }

                return .none
                
            case .keyPointDidUpdate:
                // TODO: Should be handled somehow
                guard let currentKeyPoint = state.bookInfo.currentKeyPoint else { return .none }

                state.keyPointText = formatter.formatKeyPoint(
                    current: state.bookInfo.currentIndex! + 1,
                    total: state.bookInfo.keyPointTotal
                )
                state.keyPointDescriptionText = currentKeyPoint.description

                state.playbackControlButtonsState.backwardEndIsEnabled = !state.bookInfo.currentKeyPointIsFirst
                state.playbackControlButtonsState.forwardEndIsEnabled = !state.bookInfo.currentKeyPointIsLast

                let currentKeyPointAudioURL = currentKeyPoint.audioURL
                audioClient.setCurrentItemURL(currentKeyPointAudioURL)

                return .send(.updateCurrentTime(currentTime: .zero)).concatenate(
                    with: .publisher {
                        audioClient.currentTimeIntervalPublisher.map { .updateCurrentTime(currentTime: $0) }
                    }
                )

            case .audioItemDurationDidUpdate(let duration):
                // Update rate button
                let current = rateProvier.currentValue
                state.currentSpeedRateText = formatter.formatSpeedRate(current)
                // Update duration and maxTimelineLabel
                state.timelineState.maxTimeInterval = duration
                let maxTimeInterval = state.timelineState.maxTimeInterval
                state.timelineState.maxTimelineLabel = formatter.formatTimeIntervalToTime(maxTimeInterval)

                return .send(.updateMode(.presenting))

            case .updateCurrentTime(let timeInterval):
                state.timelineState.currentTimeInterval = timeInterval
                // Update current timeline label
                let currentTimeInterval = state.timelineState.currentTimeInterval
                state.timelineState.currentTimelineLabel = formatter.formatTimeIntervalToTime(currentTimeInterval)

                // Automatic playback of the next item
                if timeInterval != .zero, floor(timeInterval) >= floor(state.timelineState.maxTimeInterval) {
                    if state.bookInfo.currentKeyPointIsLast {
                        // Here should be a summary
                    } else {
                        return .send(.playbackControlButtonsAction(.forwardEndButtonTapped)).concatenate(
                            with: .send(.playbackControlButtonsAction(.playbackSwitchChanged(true)))
                        )
                    }
                }

                return .none

            case .rateButtonDidTap:
                let newRate = rateProvier.next()
                state.currentSpeedRateText = formatter.formatSpeedRate(newRate)
                audioClient.setPlaybackRate(newRate)

                return .none

            case .playbackControlButtonsAction(let action):

                switch action {
                case .backwardEndButtonTapped:
                    return .send(.bookInfoAction(.prevKeyPoint)).concatenate(
                        with: .send(.keyPointDidUpdate)
                    )

                case .backwardButtonTapped:
                    audioClient.backward(seconds: 5)
                    return .none

                case .playbackSwitchChanged(let isPlaying):
                    state.playbackControlButtonsState.isPlaying = isPlaying

                    if isPlaying {
                        audioClient.play()
                    } else {
                        audioClient.pause()
                    }

                    return .none

                case .forwardButtonTapped:
                    audioClient.forward(seconds: 10)
                    return .none

                case .forwardEndButtonTapped:
                    return .send(.bookInfoAction(.nextKeyPoint)).concatenate(
                        with: .send(.keyPointDidUpdate)
                    )
                }

            case .timelineAction(let action):

                switch action {
                case .onAppear:
                    return .none

                case .timelineValueChanged(let value):
                    state.timelineState.currentTimeInterval = value
                    audioClient.seek(to: value)
                    return .none
                }

            case .bookInfoAction:
                return .none

            case .alert(.presented(.crashApp)):
                // Only to show that this screen should be closed. See BookClient.swift error simulation
                fatalError()

            case .alert(.dismiss):
                return .none

            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
