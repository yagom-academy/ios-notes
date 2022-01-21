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
        self.noteListViewModel.notes()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.selectedNote = nil
        self.showNoteDetail(note: nil)
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
            }
        }
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
        } else {
//            noteViewController.setViews()
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
        self.noteListViewModel.notes()
    }
}

// MARK: - Table view delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // edit 화면에서 입력중이던 내용 저장
        self.noteViewController?.addOrUpdateNote()

        self.selectedNote = noteList?[indexPath.row]
        self.showNoteDetail(note: self.selectedNote)
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "delete") {
            (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let noteList = self.noteList else { return }

            let note = noteList[indexPath.row]
            self.deleteNote(note: note, indexPath: indexPath)
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }

    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") {
            (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let noteList = self.noteList else { return }

            self.callActivityViewController(entireContents: noteList[indexPath.row].entireContents)
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NoteTableViewCell else {
            return UITableViewCell()
        }

        guard let noteList = self.noteList else {
            return cell
        }

        cell.titleLabel.text = noteList[indexPath.row].title
        cell.shortDescriptionLabel.text = noteList[indexPath.row].contents

        let dateFormatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeID)
        }

        dateFormatter.dateStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: noteList[indexPath.row].date)

        return cell
    }

//    override func tableView(
//        _ tableView: UITableView,
//        commit editingStyle: UITableViewCell.EditingStyle,
//        forRowAt indexPath: IndexPath
//    ) {
//        switch editingStyle {
//        case .delete:
//            guard let noteList = self.noteList else { return }
//
//            let note = noteList[indexPath.row]
//            self.deleteNote(note: note, indexPath: indexPath)
//        default:
//            return
//        }
//    }
}
