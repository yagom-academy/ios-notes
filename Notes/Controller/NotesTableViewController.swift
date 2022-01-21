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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

extension NotesTableViewController :NoteEdittedDelegate {
    func notifyNoteEditted() {
        notes = PersistenceManager.shared.fetchNotes(request: Note.fetchRequest())
        tableView.reloadData()
    }
    
}

protocol NoteSelectionDelegate: AnyObject {
    func noteSelected(_ note: Note)
}
