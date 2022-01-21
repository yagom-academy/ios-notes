//
//  Note.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//

import Foundation

struct Note {
    var id: UUID = UUID()
    var title: String
    var lastModified: Date
    var content: String
}

extension Note {
    func toViewForm() -> String {
        return title + "\n" + content
    }

    static func makeFromViewForm(_ viewFormText: String, id: UUID) -> Note {
        let splitTexts = viewFormText.split(separator: "\n", maxSplits: 1)
        let title = splitTexts.first ?? Substring()
        let content = (splitTexts.count == 2) ? (splitTexts.last ?? Substring()) : Substring()

        return Note(id: id, title: String(title), lastModified: Date(), content: String(content))
    }
}
