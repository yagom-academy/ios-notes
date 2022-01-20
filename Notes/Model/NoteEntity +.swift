//
//  NoteEntity +.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//

import CoreData
import Foundation

extension NoteEntity {
    var lastModifiedDate: Date {
        Date(timeIntervalSince1970: lastModified)
    }
}
