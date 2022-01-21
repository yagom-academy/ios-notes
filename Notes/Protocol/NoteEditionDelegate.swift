//
//  NoteEditionDelegate.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//

import Foundation

protocol NoteEditionDelegate: AnyObject {
    func notifyNoteEditted()
    func share(_ note: Note)
    func delete(_ note: Note)
}
