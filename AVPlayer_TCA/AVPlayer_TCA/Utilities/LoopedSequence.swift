//
//  LoopedSequence.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import Foundation

/// - Warning: Init contains preconditions that can lead to a runtime error
final class LoopedSequence<T> {
    private let values: [T]
    private var currentIndex = 0

    var currentValue: T {
        return values[currentIndex]
    }

    /// Creates LoopedSequence.
    /// - parameter values: The array can not be empty.
    /// - parameter currentIndex: Current value can not be negative and lower than `values.count``.
    init(_ values: [T], currentIndex: Int = 0) {
        // Given that this is a test task
        precondition(!values.isEmpty, "LoopedSequence must not be initialized with an empty array.")
        precondition(currentIndex >= 0 && currentIndex < values.count, "Invalid currentIndex provided.")

        self.values = values
        self.currentIndex = currentIndex
    }

    /// - Returns: Returns next value in the sequence. If `currentValue` is the last value, then `next` will be the first value on the stack.
    func next() -> T {
        // ex. 6 % 6 = 0, that is, the next index after 5 will be 0, provided that there are 6 elements in total
        currentIndex = (currentIndex + 1) % values.count
        return currentValue
    }
}
