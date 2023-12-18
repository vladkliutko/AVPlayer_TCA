//
//  PlaybackTimelineControlView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import SwiftUI
import ComposableArchitecture

struct PlaybackTimelineControlView: View {
    let store: StoreOf<PlaybackTimelineControl>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(spacing: 16) {
                if !viewStore.currentTimelineLabel.isEmpty {
                    buildTimelineLabel(with: viewStore.currentTimelineLabel)
                }

                SliderView(
                    maxValue: viewStore.maxTimeInterval,
                    value: viewStore.binding(get: \.currentTimeInterval, send: { .timelineValueChanged($0) })
                )
                .foregroundStyle(ColorPalette.primary)

                if !viewStore.maxTimelineLabel.isEmpty {
                    buildTimelineLabel(with: viewStore.maxTimelineLabel)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    @ViewBuilder
    func buildTimelineLabel(with text: String) -> some View {
        Text(text)
            .monospacedDigit()
            .font(.footnote)
            .foregroundStyle(ColorPalette.textSecondary)
    }
}

#Preview {
    PlaybackTimelineControlView(
        store: Store(initialState: PlaybackTimelineControl.State(), reducer: {
            PlaybackTimelineControl()
        })
    )
    .padding(32)
}
