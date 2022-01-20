//
//  MainSplitViewController.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    // TODO: 데이터 코어데이터로 대체
    var notes: [Note] = {
        var arr = [Note]()
        for num in 0..<10 {
            arr.append(Note(title: "Dummy\(num)", lastModified: Date(), content: "dummy\(num)"))
        }
        return arr
    }()

    weak var noteViewController: NoteViewController?
    var noteTableViewController: NotesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
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

    func updateNote(at position: Int, with newNote: Note) {
        let oldNote: Note = notes[position]
        guard oldNote.id == newNote.id else {
            fatalError("ID missmatch on note modification")
        }
        notes[position] = newNote
        let cellIndexPath = IndexPath(row: position, section: 0)
        noteTableViewController?.tableView.reloadRows(at: [cellIndexPath], with: .none)
    }
}

extension MainSplitViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? NoteTableViewCell else {
            fatalError()
        }
        let note = notes[indexPath.row]
        cell.configureContent(note)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNote(position: indexPath.row)
    }
}
