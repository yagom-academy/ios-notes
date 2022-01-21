//
//  Notes - NoteViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol NoteEdittedDelegate: AnyObject {
    func notifyNoteEditted()
    func share(_ note: Note)
    func delete(_ note: Note)
}

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    weak var delegate: NoteEdittedDelegate?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
    }
    @IBAction func moreButtonClicked(_ sender: Any) {
        guard let note = note else { return }
        let actionSheetAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.delegate?.share(note)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.delete(note)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetAlertController.addAction(shareAction)
        actionSheetAlertController.addAction(deleteAction)
        actionSheetAlertController.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad,
           let popoverController = actionSheetAlertController.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        present(actionSheetAlertController, animated: true,completion: nil)
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

