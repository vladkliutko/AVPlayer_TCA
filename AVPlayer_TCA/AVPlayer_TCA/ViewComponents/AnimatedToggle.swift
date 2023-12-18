//
//  AnimatedToggle.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 18.12.2023.
//

import SwiftUI

struct AnimatedToggle: View {
    
    @State var toggleOn: Bool

    private let onImage: Image
    private let offImage: Image

    init(toggleOn: Bool, onImage: Image, offImage: Image) {
        self.toggleOn = toggleOn
        self.onImage = onImage
        self.offImage = offImage
    }

    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.white)
                .frame(width: 110, height: 52)
                .overlay(
                    Capsule()
                        .stroke(ColorPalette.secondary)
                )
            ZStack {
                Circle()
                    .frame(height: 48)
                    .foregroundColor(ColorPalette.primary)
                    .offset(x: toggleOn ? 28 : -28)
                HStack(spacing: 34) {
                    offImage
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(toggleOn ? .black : .white)
                    onImage
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(toggleOn ? .white : .black)
                }
            }
            .animation(.spring, value: toggleOn)

        }
        .onTapGesture {
            toggleOn.toggle()
        }
    }
}
