//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {
    private var notes: [NoteEntity] = []
    
    weak var noteViewController: NoteViewController?
    weak var noteNavigation: UINavigationController?
    
    let noteCoreData: NoteCoreDataStorage = NoteCoreDataStorage.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTest()
        fetchNote()
        
        if splitViewController?.isCollapsed == false, !notes.isEmpty {
            showNoteViewController(note: notes[0])
        }
    }
    
    // MARK: - fetch
    func fetchTest() {
        guard let jsonData: Data = FileLoader.shared.readDataSet(fileName: "sample") else {
            return
        }
        
        guard let model: [NoteModel] = JSONParser.shared.decode([NoteModel].self, from: jsonData) else {
            return
        }
        model.forEach {
            print($0.lastModified)
        }
    }
    
    func fetchNote() {
        notes = noteCoreData.fetch()
        tableView.reloadData()
    }
    
    // MARK: - Methods
    @IBAction private func addNewNote(_ sender: Any) {
        noteCoreData.insertNewNote()
        fetchNote()
        showNoteViewController(note: notes[0])
    }
    
    func showNoteViewController(note noteEntity: NoteEntity?) {
        guard let noteNavigation = noteNavigation,
              let noteViewController = noteViewController else {
                  return
              }
        noteViewController.noteEntity = noteEntity
        
        if splitViewController?.isCollapsed == true {
            if noteEntity == nil {
                navigationController?.popViewController(animated: true)
            } else {
                splitViewController?.showDetailViewController(noteNavigation, sender: nil)
            }
        } else {
            noteViewController.updateView()
        }
    }
    
    func checkNextShowNoteViewController(deletedIndex index: Int) {
        var nextShowIndex: Int = index
        if notes.count <= index {
            if index - 1 >= 0 {
                nextShowIndex = index - 1
            }
        }
        if notes.isEmpty {
            showNoteViewController(note: nil)
            return
        }
        if splitViewController?.isCollapsed == false {
            showNoteViewController(note: notes[nextShowIndex])
        } else {
            noteViewController?.noteEntity = notes[nextShowIndex]
            navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteNotes(indexPath: IndexPath) {
        noteCoreData.delete(notes[indexPath.row])
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        checkNextShowNoteViewController(deletedIndex: indexPath.row)
    }
}

// MARK: - Table view data source
extension NotesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                                          for: indexPath) as? NoteTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.updateView(by: notes[indexPath.row])
        return cell
    }
}

// MARK: - Table view Delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNoteViewController(note: notes[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction: UIContextualAction = UIContextualAction(style: .normal, title: "공유") { _, _, _ in
            self.showActivityView(note: self.notes[indexPath.row])
        }
        
        let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
            self.showDeleteAlert(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
    }
}

// MARK: - NoteViewControllerObserver
extension NotesTableViewController: NoteViewControllerObserver {
    func noteViewControllerDidChange() {
        fetchNote()
    }
    
    func noteViewControllerDidClickMoreButton(note: NoteEntity) {
        showAlertSheet(note: note)
    }
}

// MARK: - Alert
extension NotesTableViewController {
    func showAlertSheet(note: NoteEntity) {
        let alertSheet: UIAlertController = UIAlertController(title: "공유 또는 삭제", message: "", preferredStyle: .actionSheet)
        let shareAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView(note: note)
        }
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let index: Int = self.notes.firstIndex(of: note) else {
                return
            }
            self.showDeleteAlert(indexPath: IndexPath(row: index, section: 0))
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancle", style: .cancel) { _ in
        }
        alertSheet.addAction(shareAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    func showDeleteAlert(indexPath: IndexPath) {
        let alertSheet: UIAlertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteNotes(indexPath: indexPath)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancle", style: .cancel) { _ in
        }
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    func showActivityView(note: NoteEntity) {
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [note.body ?? ""], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
