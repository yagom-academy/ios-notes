//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController, ModifyDelegate {

    @IBOutlet var noteTableView: UITableView!

    weak var noteViewController: NoteViewController?
    weak var noteNavigationController: UINavigationController?

    var noteListViewModel = NoteListViewModel()
    var noteDetailViewModel = NoteDetailViewModel()
    private var noteList: [Note]?
    private var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.noteViewController?.delegate = self
        self.setViewModel()
        self.noteListViewModel.fetchNotes()
    }

    @IBAction func pressAddButton(_ sender: UIBarButtonItem) {
        let newNote = self.createEmptyNote()
        self.noteDetailViewModel.addNote(note: newNote) { [weak self] in
            guard let self = self else { return }

            self.noteListViewModel.fetchNotes()
        }

        self.showNoteDetail(note: newNote)
    }

    private func setViewModel() {
        self.noteListViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.noteList = self.noteListViewModel.noteList?.sorted { $0.date > $1.date }
            DispatchQueue.main.async {
                self.noteTableView.reloadData()
            }
        }
    }

    private func deleteNote(note: Note, indexPath: IndexPath) {
        self.noteDetailViewModel.deleteNote(note: note) { [weak self] in
            guard let self = self else { return }

            self.noteList?.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.noteTableView.deleteRows(at: [indexPath], with: .fade)
                self.noteViewController?.noteTextView.text = ""
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

    private func showNoteDetail(note: Note?) {
        guard let noteNavigationController = self.noteNavigationController,
              let noteViewController = self.noteViewController else {
            return
        }

        noteViewController.noteTableViewController = self
        noteViewController.note = note

        guard let splitViewController = self.splitViewController else { return }

        noteViewController.setViews()
        if splitViewController.isCollapsed == true {
            splitViewController.showDetailViewController(noteNavigationController, sender: nil)
        }
    }

    func callActivityViewController(entireContents: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [entireContents],
            applicationActivities: nil
        )
        self.present(activityViewController, animated: true, completion: nil)
    }

    func modify() {
        self.noteListViewModel.fetchNotes()
    }
}

// MARK: - Table view delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedNote = noteList?[indexPath.row]

        let topIndexPath = IndexPath(row: 0, section: 0)
        if let topInexPathNote = noteList?[topIndexPath.row],
           topInexPathNote.entireContents == "" {
            self.deleteNote(note: topInexPathNote, indexPath: topIndexPath)
        }

        self.showNoteDetail(note: self.selectedNote)
    }

    // swipe(<-): delete note
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let noteList = self.noteList else { return }

            let note = noteList[indexPath.row]
            self.deleteNote(note: note, indexPath: indexPath)
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }

    // swipe(->): share note
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let noteList = self.noteList else { return }

            ViewControllerCaller.callActivityViewController(
                entireContents: noteList[indexPath.row].entireContents,
                viewController: self
            )
            success(true)
        }
        share.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions: [share])
    }
}

// MARK: - Table view data source
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell,
              let noteList = self.noteList else {
                  return UITableViewCell()
              }

        cell.updateCell(note: noteList[indexPath.row])
        return cell
    }
}
