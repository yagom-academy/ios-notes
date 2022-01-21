//
//  Notes - NoteViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol NoteEdittedDelegate: AnyObject {
    func notifyNoteEditted()
}

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    weak var delegate: NoteEdittedDelegate?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
    }
}

extension NoteViewController: NoteSelectionDelegate {
    func noteSelected(_ note: Note) {
        noteTextView.text = note.content
        self.note = note
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = noteTextView.text else { return }
        let lineChangedIndex = text.firstIndex(of: "\n") ?? text.endIndex
        let title = text[..<lineChangedIndex]
        note?.title = String(title)
        note?.content = text
        note?.date = Date()
        delegate?.notifyNoteEditted()
    }
}

