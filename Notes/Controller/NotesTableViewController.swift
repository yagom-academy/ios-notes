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
    
    //var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.configureCell(with: notes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectNote = notes[indexPath.row]
        guard let splitViewController = splitViewController else { return }
        if splitViewController.viewControllers.count > 1 {
            guard let noteNavigationViewController = splitViewController.viewControllers[1] as? UINavigationController,
                  let noteViewController = noteNavigationViewController.topViewController as? NoteViewController else { return }
            noteViewController.selectedNote = selectNote
            splitViewController.showDetailViewController(noteNavigationViewController, sender: nil)
        } else {
            guard let noteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController else { return }
            let noteNavigationController = UINavigationController(rootViewController: noteViewController)
            _ = noteViewController.view
            noteViewController.selectedNote = selectNote
            splitViewController.showDetailViewController(noteNavigationController, sender: nil)
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

protocol NoteSelectionDelegate: AnyObject {
    func noteSelected(_ note: JsonNote)
}
