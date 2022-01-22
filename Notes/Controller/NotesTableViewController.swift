//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class NotesTableViewController: UITableViewController {

    @IBOutlet var noteListTable: UITableView!
    private var notes: [UserNotes] = []
    var firstNavigationController: UINavigationController?
    var secondNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let decodedData = decodeJSONData(type: [NoteForm].self, from: "sample") {
//            self.notes = decodedData
//        }
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        firstNavigationController = sceneDelegate.firstNavigationController
        secondNavigationController = sceneDelegate.secondNavigationController
        
        
//        print(splitViewController?.children)
//        print(splitViewController?.viewControllers)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notes = fetchNoteData()
        noteListTable.reloadData()
    }
    
    func fetchNoteData() -> [UserNotes] {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return [] }
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<UserNotes>(entityName: "UserNotes")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    @IBAction func touchUpAddButton(_ sender: Any) {
        let newNoteView = NewNoteViewController()
        newNoteView.modalPresentationStyle = .fullScreen
        self.present(newNoteView, animated: true, completion: nil)
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
                                                 for: indexPath) as? NoteTableViewCell ?? NoteTableViewCell()
        cell.setContents(with: notes[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let noteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController else { return }
        guard let noteViewController = secondNavigationController?.children.first as? NoteViewController else { return }
        
        noteViewController.data = notes[indexPath.row].noteBody
        if UITraitCollection.current.horizontalSizeClass == .regular {
            noteViewController.reload()
        }
        
        
        guard let secondNavigationController = secondNavigationController else {
            return
        }

        splitViewController?.showDetailViewController(secondNavigationController,sender: self)
        noteListTable.deselectRow(at: indexPath, animated: true)
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
