//
//  AVPlayer_TCAApp.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct AVPlayer_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            BookKeyPointsView(
                store: Store(
                    initialState: BookKeyPoints.State(
                        bookInfo: BookInfo.State(),
                        timelineState: PlaybackTimelineControl.State(),
                        playbackControlButtonsState: PlaybackControlButtons.State()
                    )
                ) {
                    BookKeyPoints()._printChanges()
                }
            )
            .preferredColorScheme(.light) // In order to reduce the amount of work
        }
    }
}
