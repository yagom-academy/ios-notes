//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    private var noteDetailViewModel = NoteDetailViewModel()
    var noteTableViewController: NotesTableViewController?
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewModel()
        self.noteDetailViewModel.note(id: note?.id)
        self.setViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.addOrUpdateNote()
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
        if self.note == nil {
            note = Note(
                id: UUID().uuidString,
                title: "temp title",
                contents: noteTextView.text,
                date: "temp date"
            )
        }

        guard var note = self.note else { return }

        note.contents = self.noteTextView.text
        self.noteDetailViewModel.addOrUpdateNote(note: note) {
            self.noteTableViewController?.noteListViewModel.notes()
            print("ok")
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }

        self.noteDetailViewModel.deleteNote(note: note) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
