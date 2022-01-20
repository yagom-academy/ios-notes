//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    private var noteCoreDatas: [NoteEntity] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notes = Decoder.decodeJSONData(type: [Note].self, from: "sample") ?? []
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        for note in notes {
            let data = NoteEntity(context: context)
            data.title = note.title
            data.body = note.body
            data.date = note.date
        }
        do {
            try context.save()
        } catch {
            print("save error")
        }
        loadCoreData()
//        fetchResult.
//        for entity in fetchResult {
//            print(entity)
//        }
//        print(NoteEntity.fetchRequest())
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCoreData()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteCoreDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? NoteTableViewCell ?? NoteTableViewCell()
        cell.configureCell(data: noteCoreDatas[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteView: NoteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController ?? NoteViewController()
        noteView.configureView(data: noteCoreDatas[indexPath.row])
        if UITraitCollection.current.horizontalSizeClass == .compact {
            navigationController?.pushViewController(noteView, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            guard let secondeNavigationController: UINavigationController = splitViewController?.viewControllers[1] as? UINavigationController else { return }
            secondeNavigationController.pushViewController(noteView, animated: true)
        }
    }
    
    func loadCoreData() {
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NoteEntity.fetchRequest()
        do {
            noteCoreDatas = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}
