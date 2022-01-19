//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {
    private var notes: [NoteModel] = []
    
    weak var noteViewController: NoteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTest()
    }
    
    func fetchTest() {
        guard let jsonData: Data = FileLoader.shared.readDataSet(fileName: "sample") else {
            return
        }
        
        guard let model: [NoteModel] = JSONParser.shared.decode([NoteModel].self, from: jsonData) else {
            return
        }
        notes = model
    }

    // MARK: - Table view data source
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
        cell.titleLabel.text = notes[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteViewController?.noteModel = notes[indexPath.row]
        splitViewController?.showDetailViewController(noteViewController!, sender: nil)
        if splitViewController?.isCollapsed == false {
            noteViewController?.updateView()
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
