//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    private var notes: [Note] = []
    var noteRepository: NoteRepositoryType?

    weak var noteSelectionDelegate: NoteSelcetionDelegate?

    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func fetchData() {
        self.noteRepository?.fetchNoteData(completion: { notes in
            guard let notes = notes else {
                return
            }
            self.notes = notes
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteTableViewCell.reuseIdentifier,
            for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }

        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.shortDescriptionLabel.text = note.content
        cell.dateLabel.text = note.lastModified.dateString()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        self.noteSelectionDelegate?.noteSelected(selectedNote)

        if let noteViewController = self.noteSelectionDelegate as? NoteViewController,
           let noteNavigationViewController = noteViewController.navigationController {
            self.splitViewController?.showDetailViewController(noteNavigationViewController, sender: nil)
        }
    }

}
