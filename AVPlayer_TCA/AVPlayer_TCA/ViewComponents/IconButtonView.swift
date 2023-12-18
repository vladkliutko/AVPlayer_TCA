//
//  IconButtonView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import SwiftUI

struct IconButtonView: View {

    private let icon: Image
    private let iconSize: CGSize
    private let action: () -> Void

    init(icon: Image, iconSize: CGSize, action: @escaping () -> Void) {
        self.icon = icon
        self.iconSize = iconSize
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: iconSize.width, height: iconSize.height)
        }
    }
}
