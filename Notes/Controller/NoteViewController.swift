//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    var mainViewContoller: MainSplitViewController?

    var notePosition: Int?
    var note: Note?

    private let defaultText = "편집할 메모를 선택하거나, 새로운 메모를 추가해주세요!"

    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewContoller = splitViewController as? MainSplitViewController
        noteTextView.delegate = self
        configureContent(note: note)
    }

    private func configureContent(note: Note?) {
        guard let note = note else {
            return
        }
        noteTextView.text = note.title + "\n" + note.content
        noteTextView.isEditable = true
        noteTextView.isSelectable = true

        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(menuButtonTouchUp(_:))
    }

    func deactivateContent() {
        notePosition = nil
        noteTextView.isEditable = false
        noteTextView.isSelectable = false
        noteTextView.text = defaultText
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    private func shareNoteAction(action: UIAlertAction) {
        let activityViewContoller = UIActivityViewController(activityItems: [noteTextView.text ?? ""],
                                                             applicationActivities: nil)
        activityViewContoller.popoverPresentationController?.sourceView = self.view
        self.present(activityViewContoller, animated: true, completion: nil)
    }

    private func deleteNoteAction(action: UIAlertAction) {
        guard let notePosition = notePosition else {
            return
        }
        mainViewContoller?.deleteNote(at: notePosition)
    }

    @objc private func menuButtonTouchUp(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let shareAction = UIAlertAction(title: "공유", style: .default, handler: shareNoteAction)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteNoteAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let notePosition = notePosition else {
            return
        }
        let splitTexts = textView.text.split(separator: "\n", maxSplits: 1)

        let changedTitle = String(splitTexts.first ?? Substring())
        let changedContent: String
        if splitTexts.count == 2, let lastSubstring = splitTexts.last {
            changedContent = String(lastSubstring)
        } else {
            changedContent = ""
        }

        mainViewContoller?.updateNote(at: notePosition, title: changedTitle, content: changedContent)
    }
}
