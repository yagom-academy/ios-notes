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
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        firstNavigationController = sceneDelegate.firstNavigationController
        secondNavigationController = sceneDelegate.secondNavigationController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView()
    }
    
    func reloadTableView() {
        self.notes = fetchNoteData()
        self.notes.reverse()
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
        loadNoteView(with: nil)
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
        loadNoteView(with: notes[indexPath.row])
        noteListTable.deselectRow(at: indexPath, animated: true)
    }
    
    func loadNoteView(with noteData: UserNotes?) {
        print(UITraitCollection.current.horizontalSizeClass.rawValue)
        
        guard let noteViewController = secondNavigationController?.children.first as? NoteViewController else { return }
        
        noteViewController.data = noteData
        
        if UITraitCollection.current.horizontalSizeClass == .regular {
            // action 버튼 누르고 나면 얘가 안먹음
            noteViewController.reload()
        }
        
        guard let secondNavigationController = secondNavigationController else {
            return
        }

        splitViewController?.showDetailViewController(secondNavigationController, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (_, _, _) in
            
            guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
            let context = container.viewContext
            
            context.delete(self.notes[indexPath.row])
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            self.reloadTableView()
            self.firstNavigationController?.popViewController(animated: true)
            let rightNote = self.secondNavigationController?.children.first as? NoteViewController
            rightNote?.data = nil
            rightNote?.reload()
            
            
        })
        let shareButton = UIContextualAction(style: .normal, title: "Share", handler: {
            (_, _, _) in
            let shareText: String? = self.notes[indexPath.row].title
            var shareObject = [Any]()
            shareObject.append(shareText)
            let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        })
        shareButton.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [deleteButton, shareButton])
    }
}
