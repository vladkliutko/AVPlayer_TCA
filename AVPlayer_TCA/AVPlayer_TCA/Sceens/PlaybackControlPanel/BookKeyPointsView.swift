//
//  BookKeyPointsView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import SwiftUI
import ComposableArchitecture

struct BookKeyPointsView: View {
    let store: StoreOf<BookKeyPoints>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                ColorPalette.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Placeholder for the book cover
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 180, height: 260)
                        .foregroundColor(ColorPalette.secondary)

                    Text(viewStore.keyPointText)
                        .tracking(1.3)
                        .textCase(.uppercase)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(ColorPalette.textSecondary)
                        .padding(.top, 42)

                    Text(viewStore.keyPointDescriptionText)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .regular))
                        .frame(maxHeight: 64, alignment: .top) // To prevent "jumping" of interface
                        .padding(.top, 14)
                        .padding(.horizontal, 40)
                        .foregroundColor(ColorPalette.textMain)

                    Group {
                        PlaybackTimelineControlView(
                            store: store.scope(state: \.timelineState, action: { .timelineAction($0) })
                        )
                        .padding(.top, 4)
                        .padding(.horizontal, 16)

                        buildSpeedRateButton(title: viewStore.currentSpeedRateText) {
                            viewStore.send(.rateButtonDidTap)
                        }
                        .padding(.top, 21)
                    }
                    .opacity(viewStore.mode == .presenting ? 1 : 0)

                    PlaybackControlButtonsView(
                        store: store.scope(
                            state: \.playbackControlButtonsState,
                            action: { .playbackControlButtonsAction($0) }
                        )
                    )
                    .padding(.top, 46)

                    Spacer()

                    // Toggle does nothing but looks pretty.
                    AnimatedToggle(
                        toggleOn: true,
                        onImage: Image(systemName: "headphones"),
                        offImage: Image(systemName: "text.justify.left")
                    )
                }
                .padding(.top, 18)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .alert(
                  store: self.store.scope(state: \.$alert, action: \.alert)
                )
            }
        }
    }

    @ViewBuilder
    func buildSpeedRateButton(title: String, action: @escaping () -> Void) -> some View {
        Text(title)
            .foregroundStyle(ColorPalette.textMain)
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 4, style: .circular)
                    .foregroundStyle(ColorPalette.secondary)
            }
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    BookKeyPointsView(
        store: Store(
            initialState: BookKeyPoints.State(
                bookInfo: BookInfo.State(),
                timelineState: PlaybackTimelineControl.State(),
                playbackControlButtonsState: PlaybackControlButtons.State()
            )
        ) {
            BookKeyPoints()
        }
    )
}
