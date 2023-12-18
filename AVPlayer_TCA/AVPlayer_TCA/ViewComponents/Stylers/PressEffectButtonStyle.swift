//
//  PressEffectButtonStyle.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import SwiftUI

struct PressEffectButtonStyle: ButtonStyle {

    let effectPadding: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(effectPadding)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .background {
                Circle()
                    .foregroundColor(.gray)
                    .opacity(configuration.isPressed ? 0.2 : 0)
            }
    }
}
