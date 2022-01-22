//
//  MainSplitViewController.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    lazy var notes: [Note] = { NoteContainerManager.shared.fetch() }()

    weak var noteViewController: NoteViewController?
    var noteTableViewController: NotesTableViewController?

    override func viewWillDisappear(_ animated: Bool) {
        NoteContainerManager.shared.saveContext()
    }

    func showNote(position: Int) {
        guard let noteNavigationViewController = storyboard?
                .instantiateViewController(withIdentifier: "NoteNVC") as? UINavigationController,
              let newNoteViewController = noteNavigationViewController.topViewController as? NoteViewController else {
                  fatalError("StoryboardID mismatch or failed type casting")
        }
        let selectedNote = notes[position]
        newNoteViewController.note = selectedNote
        newNoteViewController.notePosition = position

        showDetailViewController(noteNavigationViewController, sender: nil)
        self.noteViewController = newNoteViewController
    }

    func updateNote(at position: Int, title: String, content: String) {
        let modifiedNote: Note = notes[position]
        modifiedNote.setValue(title, forKey: "title")
        modifiedNote.setValue(content, forKey: "content")
        modifiedNote.setValue(Date(), forKey: "lastModified")

        let cellIndexPath = IndexPath(row: position, section: 0)
        noteTableViewController?.tableView.reloadRows(at: [cellIndexPath], with: .none)
    }

    func addNote() {
        notes.insert(NoteContainerManager.shared.make(), at: 0)
        let zeroIndextPath = IndexPath(row: 0, section: 0)
        noteTableViewController?.tableView.insertRows(at: [zeroIndextPath], with: .left)
        noteTableViewController?.tableView.scrollToRow(at: zeroIndextPath, at: .top, animated: true)
    }

    func deleteNote(at position: Int) {
        if noteViewController?.notePosition == position {
            noteViewController?.deactivateContent()
        }

        if self.traitCollection.horizontalSizeClass == .compact {
            (viewControllers.first as? UINavigationController)?.popViewController(animated: true)
        }

        let deletedNote = notes[position]
        notes.remove(at: position)
        NoteContainerManager.shared.delete(deletedNote)

        noteTableViewController?.tableView.deleteRows(at: [IndexPath(row: position, section: 0)], with: .right)
    }
}
