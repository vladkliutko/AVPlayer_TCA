//
//  SpeedRateProvider.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import ComposableArchitecture

@DependencyClient
struct SpeedRateProvider {
    private var rates = LoopedSequence<Float>([0.5, 0.75, 1, 1.25, 1.5, 1.75, 2.0], currentIndex: 2)

    var currentValue: Float {
        return rates.currentValue
    }

    /// - Returns: Returns next value in the stack. If `currentValue` is the last value, then `next` will be the first value on the stack.
    func next() -> Float {
        return rates.next()
    }
}

extension SpeedRateProvider: DependencyKey {
    static var liveValue: Self {
        return SpeedRateProvider()
    }
}

extension DependencyValues {
    var speedRateProvider: SpeedRateProvider {
        get { self[SpeedRateProvider.self] }
        set { self[SpeedRateProvider.self] = newValue }
    }
}
