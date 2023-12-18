//
//  BookClient.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 17.12.2023.
//

import Foundation
import ComposableArchitecture

enum BookClientError: Error {
    case canFetchData
}

@DependencyClient
struct BookClient {
    var bookData: @Sendable (_ bookIdentifier: String) async throws -> BookInfoModel
}

extension BookClient: DependencyKey {
    static var liveValue = BookClient { _ in
        // Simulate some asynchronous operation
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        // Simulate an error condition
//        if Bool.random() {
//            throw BookClientError.canFetchData
//        }

        return TestData.book
    }
}

extension DependencyValues {
    var bookClient: BookClient {
        get { self[BookClient.self] }
        set { self[BookClient.self] = newValue }
    }
}

#warning("If you are using any of the sounds on the BBC Sound Effects site commercially, you must purchase the sound from Pro Sound Effects.")
private enum TestData {
    static let book = BookInfoModel(
        bookCoverURL: nil,
        keyPoints: [
            BookInfoModel.KeyPointModel(
                audioURL: URL(string: "https://sound-effects-media.bbcrewind.co.uk/mp3/07011193.mp3")!,
                description: "Cats are purring and meowing now.\nExcuse me, dog people."
            ),
            BookInfoModel.KeyPointModel(
                audioURL: URL(string: "https://sound-effects-media.bbcrewind.co.uk/mp3/07070229.mp3")!,
                description: "Sounds of a big city and just a certain amount of text to reach a maximum of three lines to show that the text does not jerk"
            ),
            BookInfoModel.KeyPointModel(
                audioURL: URL(string: "https://sound-effects-media.bbcrewind.co.uk/mp3/NHU05011077.mp3")!,
                description: "These are bird sounds I found on the Internet"
            )
        ]
    )
}
