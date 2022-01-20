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

        self.setViewModel()
        self.noteDetailViewModel.note(id: note?.id)
        self.setViews()
    }

    private func setViewModel() {
        self.noteDetailViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.note = self.noteDetailViewModel.note
            self.setViews()
        }
    }

    private func setViews() {
        DispatchQueue.main.async {
            guard let note = self.note else {
                self.noteTextView.text = ""
                return
            }

            self.noteTextView.text = note.contents
        }
    }

    private func addOrUpdateNote() {
        guard let note = self.note else { return }

        self.noteDetailViewModel.addOrUpdateNote(note: note) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }

        self.noteDetailViewModel.deleteNote(note: note) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
