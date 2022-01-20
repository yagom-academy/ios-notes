//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class NotesTableViewController: UITableViewController {

    private var notes: [JsonNote] = []
    weak var delegate: NoteSelectionDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = JsonNote.fectchSampleDate()
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
    
}

protocol NoteSelectionDelegate: AnyObject {
    func noteSelected(_ note: JsonNote)
}
