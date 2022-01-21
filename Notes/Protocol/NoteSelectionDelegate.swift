//
//  NoteSelectionDelegate.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//

import Foundation

protocol NoteSelectionDelegate: AnyObject {
    func noteSelected(_ note: Note)
}
