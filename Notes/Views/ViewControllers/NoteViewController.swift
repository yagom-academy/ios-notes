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
    private var willAddOrUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()

        willAddOrUpdate = true
        self.setViewModel()
        self.noteDetailViewModel.note(id: note?.id)
        self.setViews()
    }

    @IBAction func moreDetailsButtonPressed(_ sender: UIBarButtonItem) {
        showActionSheet()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.willAddOrUpdate {
            self.addOrUpdateNote()
        }
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
        guard self.noteTextView.text != "" else { return }

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
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }
        self.noteDetailViewModel.deleteNote(note: note) {
            self.noteTableViewController?.noteListViewModel.notes()
            DispatchQueue.main.async {
                self.willAddOrUpdate = false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let share = UIAlertAction(title: ActionSheetType.shareNote.description, style: .default, handler: {_ in

        })

        let delete = UIAlertAction(title: ActionSheetType.deleteNote.description, style: .destructive, handler: {_ in
            self.showAlert(title: Constant.alertTitle, message: Constant.alertMessage)
        })

        let cancel = UIAlertAction(title: ActionSheetType.cancel.description, style: .cancel, handler: nil)

        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
            self.deleteNote()
        })

        alert.addAction(cancel)
        alert.addAction(delete)

        self.present(alert, animated: true, completion: nil)
    }
}
