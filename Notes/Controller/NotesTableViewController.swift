//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol NoteSelectionDelegate: AnyObject {
  func noteSelected(_ selectedNote: NoteItem)
}

final class NotesTableViewController: UITableViewController {
    // MARK: - Properties
    var noteItems: [NoteItem] = []
    
    weak var delegate: NoteSelectionDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindNoteItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectTableViewRow()
    }
    
    // MARK: - Setup
    private func bindNoteItems() {
        guard let jsonData: Data = FileReader().readFileAsData(fileName: "sample", extensionType: "json"), let model = JSONParser().decode([NoteItem].self, from: jsonData) else {
            return
        }
        
        noteItems = model
        tableView.reloadData()
    }
    
    // MARK: - Functions
    private func deselectTableViewRow() {
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndex, animated: true)
    }
    
    @IBAction private func addButtonToggled(_ sender: Any) {
        print("add")
    }
}

// MARK: - Table view delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.noteSelected(noteItems[indexPath.row])
        if let noteViewController: NoteViewController = delegate as? NoteViewController,
           let secondaryNavController: UINavigationController = noteViewController.navigationController {
            splitViewController?.showDetailViewController(secondaryNavController, sender: nil)
        }
    }
}

// MARK: - Table view data source
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("No NoteTableViewCell")
        }

        cell.bind(item: noteItems[indexPath.row])
        return cell
    }
}
