//
//  BookInfo.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BookInfo {
    struct State: Equatable {
        var bookCoverURL: URL? = nil
        var currentIndex: Int? = nil

        /// - Remark: Resets `currentIndex` to zero.
        var keyPoints = [BookInfoModel.KeyPointModel]() {
            didSet {
                currentIndex = 0
            }
        }

        var currentKeyPoint: BookInfoModel.KeyPointModel? {
            guard let currentIndex = currentIndex, currentIndex < keyPointTotal else { return nil }
            return keyPoints[currentIndex]
        }

        var keyPointTotal: Int {
            return keyPoints.count
        }

        /// - Returns: Returns true if currentKeyPoint is nil
        var currentKeyPointIsLast: Bool {
            guard let currentKeyPoint = currentKeyPoint else {
                return true
            }
            return keyPoints.last == currentKeyPoint
        }

        /// - Returns: Returns true if `currentKeyPoint` is nil
        var currentKeyPointIsFirst: Bool {
            guard let currentKeyPoint = currentKeyPoint else {
                return true
            }
            return keyPoints.first == currentKeyPoint
        }
    }

    enum Action {
        case nextKeyPoint
        case prevKeyPoint
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextKeyPoint:
                guard let currentIndex = state.currentIndex, !state.currentKeyPointIsLast else {
                    return .none
                }

                state.currentIndex = currentIndex + 1
                return .none

            case .prevKeyPoint:
                guard let currentIndex = state.currentIndex, !state.currentKeyPointIsFirst else {
                    return .none
                }

                state.currentIndex = currentIndex - 1
                return .none
            }
        }
    }
}
