//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    private var noteDetailViewModel = NoteDetailViewModel()
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
        noteDetailViewModel.note(id: note?.id)
        setViews()
    }

    private func setViewModel() {
        self.noteDetailViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.note = self.noteDetailViewModel.note
        }
    }

    private func setViews() {
        guard let note = self.note else {
            self.noteTextView.text = ""
            return
        }

        self.noteTextView.text = note.contents
    }
}
