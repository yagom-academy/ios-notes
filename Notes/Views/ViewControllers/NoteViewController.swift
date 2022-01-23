//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol ModifyDelegate: AnyObject {
    func modify()
}

final class NoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var moreDetailButton: UIBarButtonItem!

    private var noteDetailViewModel = NoteDetailViewModel()
    var noteTableViewController: NotesTableViewController?
    var note: Note?
    private var willUpdateNote = true
    weak var delegate: ModifyDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.noteTextView.delegate = self
        self.setViewModel()
        self.noteDetailViewModel.fetchNoteById(id: note?.id)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setViews()
    }

    @IBAction func presseMoreDetailsButton(_ sender: UIBarButtonItem) {
        showActionSheet()
    }

    private func setViewModel() {
        self.noteDetailViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.note = self.noteDetailViewModel.note
            self.setViews()
        }
    }

    func setViews() {
        self.willUpdateNote = true
        DispatchQueue.main.async {
            guard let note = self.note else { return }

            self.noteTextView.text = note.entireContents
        }
    }

    func addNote() {
        let newNote = self.createEmptyNote()
        self.noteDetailViewModel.addNote(note: newNote) { [weak self] in
            guard let self = self else { return }

            self.delegate?.modify()
        }
    }

    func updateNote() {
        guard let entireContents = self.noteTextView.text,
              var note = self.note else {
                  return
              }

        self.modifyNoteProperty(note: &note, noteText: entireContents)
        self.noteDetailViewModel.updateNote(note: note) { [weak self] in
            guard let self = self else { return }

            self.delegate?.modify()
        }
    }

    private func deleteNote() {
        guard let note = self.note else { return }

        self.noteDetailViewModel.deleteNote(note: note) { [weak self] in
            guard let self = self else { return }

            self.willUpdateNote = false
            DispatchQueue.main.async {
                if self.splitViewController?.isCollapsed == true {
                    self.noteTableViewController?.navigationController?.popViewController(animated: true)
                } else {
                    self.note = nil
                    self.noteTextView.text = ""
                }
                self.delegate?.modify()
            }
        }
    }

    private func createEmptyNote() -> Note {
        let newNote = Note(
            id: UUID().uuidString,
            title: "",
            contents: "",
            entireContents: "",
            date: Date()
        )
        return newNote
    }

    private func modifyNoteProperty(note: inout Note, noteText: String) {
        var splitText = noteText
            .split(separator: "\n")
            .map {
                String($0)
            }
        guard splitText.count > 0 else {
            note.title = ""
            note.contents = ""
            note.entireContents = ""
            note.date = Date()
            return
        }

        let title = splitText[0]
        splitText.removeFirst()
        let contents = splitText.joined(separator: "\n")

        note.title = title
        note.contents = contents
        note.entireContents = noteText
        note.date = Date()
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let share = UIAlertAction(title: ActionSheetType.shareNote.description, style: .default, handler: {_ in
            ViewControllerCaller.callActivityViewController(
                entireContents: self.noteTextView.text,
                viewController: self
            )
        })
        let delete = UIAlertAction(title: ActionSheetType.deleteNote.description, style: .destructive, handler: {_ in
            self.showAlert(title: Constant.alertTitle, message: Constant.alertMessage)
        })
        let cancel = UIAlertAction(title: ActionSheetType.cancel.description, style: .cancel, handler: nil)

        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)

        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.barButtonItem = self.moreDetailButton
        }
        
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
    func textViewDidChange(_ textView: UITextView) {
        self.updateNote()
    }
}
