//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    var note: Note?
    var notePosition: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let noteText = note?.toViewForm() else {
            noteTextView.isEditable = false
            noteTextView.isSelectable = false
            return
        }
        noteTextView.text = noteText
        noteTextView.delegate = self
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let viewFormNote: String = textView.text
        guard let noteID = note?.id, let position = notePosition else {
            return
        }
        let newNote = Note.makeFromViewForm(viewFormNote, id: noteID)
        (splitViewController as? MainSplitViewController)?.updateNote(at: position, with: newNote)
    }
}
