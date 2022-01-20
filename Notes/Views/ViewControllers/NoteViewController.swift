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
    private var willAddOrUpdateNote = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.willAddOrUpdateNote = true
        self.setViewModel()
        self.noteDetailViewModel.note(id: note?.id)
        self.setViews()
    }

    @IBAction func moreDetailsButtonPressed(_ sender: UIBarButtonItem) {
        showActionSheet()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.willAddOrUpdateNote {
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

            self.noteTextView.text = note.entireContents
        }
    }

    private func addOrUpdateNote() {
        guard let entireContents = self.noteTextView.text else { return }

        var splitText = self.noteTextView.text
            .split(separator: "\n")
            .map {
                String($0)
            }

        let title = splitText[0]
        splitText.removeFirst()
        let contents = splitText.joined(separator: "\n")

        if self.note == nil {
            note = Note(
                id: UUID().uuidString,
                title: title,
                contents: contents,
                entireContents: entireContents,
                date: Date()
            )
        }

        guard var note = self.note else { return }

        note.title = title
        note.contents = contents
        note.entireContents = entireContents
        note.date = Date()
        self.noteDetailViewModel.addOrUpdateNote(note: note) { [weak self] in
            guard let self = self else { return }

            self.noteTableViewController?.noteListViewModel.notes()
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }
        self.noteDetailViewModel.deleteNote(note: note) { [weak self] in
            guard let self = self else { return }
            
            self.noteTableViewController?.noteListViewModel.notes()
            DispatchQueue.main.async {
                self.willAddOrUpdateNote = false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let share = UIAlertAction(title: ActionSheetType.shareNote.description, style: .default, handler: {_ in
            self.callActivityViewController(entireContents: self.noteTextView.text)
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

    private func callActivityViewController(entireContents: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [entireContents],
            applicationActivities: nil
        )
        self.present(activityViewController, animated: true, completion: nil)
    }
}
