//
//  PlaybackControlButtonsView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import SwiftUI
import ComposableArchitecture

private enum Constants {

    enum Dimensions {
        static let largeButtonSize = CGSize(width: 32, height: 32)
        static let mediumButtonSize = CGSize(width: 28, height: 28)
        static let smallButtonSize = CGSize(width: 24, height: 24)

        static let largeButtonEffectPadding: CGFloat = 15
        static let buttonEffectPadding: CGFloat = 10
    }

    enum Icons {
        static let backward = Image(systemName: "gobackward.5")
        static let forward = Image(systemName: "goforward.10")
        static let play = Image(systemName: "play.fill")
        static let pause = Image(systemName: "pause.fill")
        static let forwardEnd = Image(systemName: "forward.end.fill")
        static let backwardEnd = Image(systemName: "backward.end.fill")
    }
}

struct PlaybackControlButtonsView: View {

    enum PlaybackControlButtonType {
        case backward, backwardEnd, forwardEnd, forward
    }

    let store: StoreOf<PlaybackControlButtons>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(spacing: 4) {
                buildControlButton(.backwardEnd, isEnabled: viewStore.backwardEndIsEnabled) {
                    viewStore.send(.backwardEndButtonTapped)
                }

                buildControlButton(.backward) {
                    viewStore.send(.backwardButtonTapped)
                }

                let pressEffect = PressEffectButtonStyle(effectPadding: Constants.Dimensions.largeButtonEffectPadding)
                PlaybackSwitchButonView(
                    isLoading: viewStore.binding(get: \.isLoading, send: { .playbackSwitchChanged($0) }),
                    isPlaying: viewStore.binding(get: \.isPlaying, send: { .playbackSwitchChanged($0) }),
                    playIconImage: Constants.Icons.play,
                    pauseIconImage: Constants.Icons.pause,
                    iconSize: Constants.Dimensions.largeButtonSize
                )
                .buttonStyle(pressEffect)

                buildControlButton(.forward) {
                    viewStore.send(.forwardButtonTapped)
                }

                buildControlButton(.forwardEnd, isEnabled: viewStore.forwardEndIsEnabled) {
                    viewStore.send(.forwardEndButtonTapped)
                }
            }
        }
    }

    func buildControlButton(
        _ type: PlaybackControlButtonType,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        let pressEffect = PressEffectButtonStyle(effectPadding: type.effectPadding)
        let resultView = IconButtonView(
            icon: type.icon,
            iconSize: type.iconSize,
            action: action
        )
        .buttonStyle(pressEffect)
        .disabled(!isEnabled)
        .foregroundColor(isEnabled ? .black : .gray.opacity(0.4))

        return resultView
    }
}

// MARK: - PlaybackControlButtonType + Presentation

private extension PlaybackControlButtonsView.PlaybackControlButtonType {

    var icon: Image {
        switch self {
        case .backward: return Constants.Icons.backward
        case .backwardEnd: return Constants.Icons.backwardEnd
        case .forwardEnd: return Constants.Icons.forwardEnd
        case .forward: return Constants.Icons.forward
        }
    }

    var iconSize: CGSize {
        switch self {
        case .backward, .forward: return Constants.Dimensions.mediumButtonSize
        case .backwardEnd, .forwardEnd: return Constants.Dimensions.smallButtonSize
        }
    }

    var effectPadding: CGFloat {
        return Constants.Dimensions.buttonEffectPadding
    }
}

#Preview {
    PlaybackControlButtonsView(store: Store(initialState: PlaybackControlButtons.State(), reducer: {
        PlaybackControlButtons()
    }))
}
