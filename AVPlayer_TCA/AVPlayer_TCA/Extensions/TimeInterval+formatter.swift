//
//  TimeInterval+formatter.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import Foundation

extension TimeInterval {
    func formattedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self) ?? ""
    }
}
