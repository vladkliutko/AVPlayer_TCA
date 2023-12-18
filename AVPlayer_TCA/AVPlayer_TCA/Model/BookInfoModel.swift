//
//  BookInfoModel.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 16.12.2023.
//

import Foundation

struct BookInfoModel: Equatable {
    struct KeyPointModel: Equatable {
        let audioURL: URL
        let description: String
    }

    let bookCoverURL: URL?
    let keyPoints: [KeyPointModel]
}
