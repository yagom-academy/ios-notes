//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol ModifyDelegate {
    func modify()
}

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    private var noteDetailViewModel = NoteDetailViewModel()
    var noteTableViewController: NotesTableViewController?
    var note: Note?
    private var willAddOrUpdateNote = true
    var delegate: ModifyDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()


        self.noteTextView.delegate = self
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

    func setViews() {
        self.willAddOrUpdateNote = true
        DispatchQueue.main.async {
            guard let note = self.note else {
                self.noteTextView.text = ""
                return
            }

            self.noteTextView.text = note.entireContents
        }
    }

    func addOrUpdateNote() {
        guard let entireContents = self.noteTextView.text else { return }
        guard entireContents != "" else { return }

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

            self.delegate?.modify()
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }

        self.noteDetailViewModel.deleteNote(note: note) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.modify()
                self.willAddOrUpdateNote = false
                if self.splitViewController?.isCollapsed == true {
                    self.noteTableViewController?.navigationController?.popViewController(animated: true)
                } else {
                    self.noteTextView.text = ""
                }
            }
        }
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let share = UIAlertAction(title: ActionSheetType.shareNote.description, style: .default, handler: {_ in
            self.noteTableViewController?.callActivityViewController(entireContents: self.noteTextView.text)
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

        let cancel = UIAlertAction(title: AlertType.cancel.description, style: .cancel, handler: nil)
        let delete = UIAlertAction(title: AlertType.deleteNote.description, style: .destructive, handler: {_ in
            self.deleteNote()
        })

        alert.addAction(cancel)
        alert.addAction(delete)

        self.present(alert, animated: true, completion: nil)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.addOrUpdateNote()
    }
}
