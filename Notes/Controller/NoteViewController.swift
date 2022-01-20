//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
}

extension NoteViewController: NoteSelectionDelegate {
    func noteSelected(_ note: JsonNote) {
        noteTextView.text = note.content
    }
}

