//
//  Note.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

struct Note: Decodable {
    let title: String
    let content: String
    let lastModified: Date

    enum CodingKeys: String, CodingKey {
        case title
        case content = "body"
        case lastModified = "last_modified"
    }
}
