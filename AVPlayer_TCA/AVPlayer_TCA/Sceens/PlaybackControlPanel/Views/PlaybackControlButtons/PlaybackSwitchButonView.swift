//
//  PlaybackSwitchButonView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import SwiftUI

private enum Constants {
    static let scaleEffectMax: CGFloat = 1
    static let scaleEffectMin: CGFloat = 0.8
    static let imageOpacityMax: CGFloat = 1
    static let imageOpacityMin: CGFloat = 0
}

struct PlaybackSwitchButonView: View {

    @Binding var isLoading: Bool
    @Binding var isPlaying: Bool

    private let playIconImage: Image
    private let pauseIconImage: Image
    private let iconSize: CGSize

    init(
        isLoading: Binding<Bool>,
        isPlaying: Binding<Bool>,
        playIconImage: Image,
        pauseIconImage: Image,
        iconSize: CGSize
    ) {
        self._isLoading = isLoading
        self._isPlaying = isPlaying
        self.playIconImage = playIconImage
        self.pauseIconImage = pauseIconImage
        self.iconSize = iconSize
    }

    var body: some View {
        Button {
            isPlaying.toggle()
        } label: {
            ZStack {
                Group {
                    playIconImage
                        .resizable()
                        .scaleEffect(isPlaying ? Constants.scaleEffectMin : Constants.scaleEffectMax)
                        .opacity(isPlaying ? Constants.imageOpacityMin : Constants.imageOpacityMax)
                    pauseIconImage
                        .resizable()
                        .scaleEffect(isPlaying ? Constants.scaleEffectMax : Constants.scaleEffectMin)
                        .opacity(isPlaying ? Constants.imageOpacityMax : Constants.imageOpacityMin)
                }
                .opacity(isLoading ? 0 : 1)

                ProgressView()
                    .scaleEffect(1.8) // it's bigger than .controlSize(.large)
                    .opacity(isLoading ? 1 : 0)
            }
            .scaledToFit()
            .frame(width: iconSize.width, height: iconSize.height)
            .animation(.interactiveSpring, value: isPlaying)
        }
    }
}

#Preview {
    PlaybackSwitchButonView(
        isLoading: .constant(true),
        isPlaying: .constant(false),
        playIconImage: Image(systemName: "circle.fill"),
        pauseIconImage: Image(systemName: "circle"),
        iconSize: CGSize(width: 72, height: 72)
    )
}
