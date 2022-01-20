//
//  NoteItem.swift
//  Notes
//
//  Created by Jinwook Huh on 2022/01/18.
//

import Foundation

struct NoteItem: Codable {
    let title: String
    let body: String
    let lastModified: Double
    
    var lastModifiedDate: Date {
        Date(timeIntervalSince1970: lastModified)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
        case lastModified = "last_modified"
    }
}
