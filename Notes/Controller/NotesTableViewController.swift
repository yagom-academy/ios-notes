//
//  Notes - NotesTableViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

final class NotesTableViewController: UITableViewController {

    private var notes: [Note] = []
    weak var delegate: NoteSelectionDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        notes = PersistenceManager.shared.fetchNotes(request: Note.fetchRequest())
    }
    
    // MARK: - Actions
    @objc func addButtonTapped(){
        PersistenceManager.shared.insertNewNote()
        notifyNoteEditted()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! NoteTableViewCell
        cell.configureUI(with: notes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectNote = notes[indexPath.row]
        if let noteViewController = delegate as? NoteViewController,
           let noteViewNavigationController = noteViewController.navigationController {
            _ = noteViewController.view
            delegate?.noteSelected(selectNote)
            splitViewController?.showDetailViewController(noteViewNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, completionHandler in
            self.share(self.notes[indexPath.row])
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.delete(self.notes[indexPath.row])
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
    }
}

extension NotesTableViewController :NoteEdittedDelegate {
    func share(_ note: Note) {
        let shareText: String = "\(note.content ?? "")"
        var shareObject = [Any]()
        shareObject.append(shareText)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func delete(_ note: Note) {
        let alertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            PersistenceManager.shared.delete(object: note)
            self.notifyNoteEditted()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func notifyNoteEditted() {
        notes = PersistenceManager.shared.fetchNotes(request: Note.fetchRequest())
        tableView.reloadData()
    }
    
}

protocol NoteSelectionDelegate: AnyObject {
    func noteSelected(_ note: Note)
}
