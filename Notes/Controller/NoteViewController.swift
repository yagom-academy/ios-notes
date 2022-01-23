//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class NoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet private weak var noteTextView: UITextView!
    
    var delegate: NotesTableViewController?
    
    var data: UserNotes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        noteTextView.text = ""
        noteTextView.adjustsFontForContentSizeCategory = true
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noteTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    private func setData() {
        if let title = data?.title, let noteBody = data?.noteBody {
            noteTextView.text = "\(title)\n\(noteBody)"
        } else {
            noteTextView.text = ""
        }
    }
    
    func reload() {
         setData()
    }
    
    @IBAction func touchUpActionButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let share = UIAlertAction(title: "Share", style: .default) {
            (action) in
            self.shareAction()
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) {
            (action) in
            self.deleteNote()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(share)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func shareAction() {
        let shareText: String? = data?.title
        var shareObject = [Any]()
        shareObject.append(shareText)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        if data == nil {
            saveNewNote(context)
        } else {
            updateNote(context)
        }
        self.delegate?.reloadTableView()
    }
    
    private func saveNewNote(_ context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "UserNotes", in: context)
        guard let entity = entity else { return }

        let noteEntity = UserNotes(entity: entity, insertInto: context)
        
        noteEntity.setValue(UUID(), forKey: "id")
        
        var stringComponents = noteTextView.text.split(separator: "\n")
        if stringComponents.count > 0 {
            noteEntity.setValue(stringComponents[0], forKey: "title")
            stringComponents.remove(at: 0)
            noteEntity.setValue(stringComponents.joined(separator: "\n"), forKey: "noteBody")
        }
        
        let time = Double(Date().timeIntervalSince1970)
        noteEntity.setValue(time, forKey: "lastModifiedDate")
        
        do {
            try context.save()
            data = noteEntity
        } catch {
            print(error)
        }
    }
    
    private func updateNote(_ context: NSManagedObjectContext) {
        
        var stringComponents = noteTextView.text.split(separator: "\n")
        if stringComponents.count == 0 {
            deleteNote()
            return
        }
        data?.setValue(stringComponents[0], forKey: "title")
        stringComponents.remove(at: 0)
        data?.setValue(stringComponents.joined(separator: "\n"), forKey: "noteBody")

        let time = Double(Date().timeIntervalSince1970)
        data?.setValue(time, forKey: "lastModifiedDate")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteNote() {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        guard let deleteData = data else { return }
        context.delete(deleteData)
        do {
            try context.save()
        } catch {
            print(error)
        }
        noteTextView.text = ""
        data = nil
        
        self.delegate?.reloadTableView()
        self.delegate?.firstNavigationController?.popViewController(animated: true)

        // 액션버튼 클릭하고 나면 안댐.... 왜지...
//        if UITraitCollection.current.horizontalSizeClass == .regular {
//            self.delegate?.reloadTableView()
//        } else if UITraitCollection.current.horizontalSizeClass == .compact {
//            self.delegate?.firstNavigationController?.popViewController(animated: true)
//        }
    }
}
