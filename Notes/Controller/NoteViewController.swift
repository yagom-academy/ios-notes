//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class NoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet private weak var noteTextView: UITextView!
    var data: UserNotes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        
        noteTextView.adjustsFontForContentSizeCategory = true
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self)
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noteTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    private func setData() {
        print(data?.title)
        print(data?.noteBody)
        
        
        if let title = data?.title, let noteBody = data?.noteBody {
            noteTextView.text = "\(title)\n\(noteBody)"
        } else {
            noteTextView.text = ""
        }
        
    }
    
    func reload() {
        setData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        if data == nil {
            // save new note
            let entity = NSEntityDescription.entity(forEntityName: "UserNotes", in: context)
            guard let entity = entity else { return }

            let noteEntity = UserNotes(entity: entity, insertInto: context)
            
            noteEntity.setValue(UUID(), forKey: "id")
            
            var stringComponents = noteTextView.text.split(separator: "\n")
            if stringComponents.count > 0 {
                print("in save process")
                print(stringComponents)
                noteEntity.setValue(stringComponents[0], forKey: "title")
                stringComponents.remove(at: 0)
                print(stringComponents)
                noteEntity.setValue(stringComponents.joined(separator: "\n"), forKey: "noteBody")
            } else {
                noteEntity.setValue("", forKey: "title")
                noteEntity.setValue("", forKey: "noteBody")
            }
            
            let time = Double(Date().timeIntervalSince1970)
            noteEntity.setValue(time, forKey: "lastModifiedDate")
            
            
            do {
                try context.save()
                data = noteEntity
            } catch {
                print("note save fail")
            }
            
        } else {
            // update note
            let updateRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserNotes")
            updateRequest.predicate = NSPredicate(format: "id == %@", data!.id as NSUUID)
            do {
                let updateObject = try context.fetch(updateRequest)[0] as? NSManagedObject
                var stringComponents = noteTextView.text.split(separator: "\n")
                updateObject?.setValue(stringComponents[0], forKey: "title")
                stringComponents.remove(at: 0)
                updateObject?.setValue(stringComponents.joined(separator: "\n"), forKey: "noteBody")
                
                let time = Double(Date().timeIntervalSince1970)
                updateObject?.setValue(time, forKey: "lastModifiedDate")
                
                do {
                    try context.save()
                    print("noted updated")
                } catch {
                    print(error)
                }
                
            } catch {
                print(error)
            }
        }
        
        
    }
}
