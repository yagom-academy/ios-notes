//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {
    // MARK: - Properties
    private var noteItems: [NoteItem] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindNoteItems()
    }
    
    // MARK: - Setup
    private func bindNoteItems() {
        guard let jsonData: Data = FileReader.shared.readFileAsData(fileName: "sample", extensionType: "json"), let model = JSONParser.shared.decode([NoteItem].self, from: jsonData) else {
            return
        }
        
        noteItems = model
        tableView.reloadData()
    }
    
    // MARK: - IBAction Functions
    @IBAction private func addButtonToggled(_ sender: Any) {
        print("add")
    }
}

// MARK: - Table view delegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteVC = storyboard?.instantiateViewController(withIdentifier: NoteViewController.storyboardItentifier) as? NoteViewController else {
            fatalError("No NoteViewController")
        }
        
        navigationController?.pushViewController(noteVC, animated: true)
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

        cell.bindCellItem(item: noteItems[indexPath.row])
        return cell
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
