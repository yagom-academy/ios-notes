//
//  NoteModel.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

struct NoteModel: Codable {
    var title: String
    var body: String
    var lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
