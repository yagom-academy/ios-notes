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
        noteTextView.text = data?.noteBody
    }
    
    func reload() {
        setData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserNotes", in: context)
        guard let entity = entity else { return }

        let noteEntity = UserNotes(entity: entity, insertInto: context)
        
        noteEntity.setValue(UUID(), forKey: "id")
        
        var stringComponents = noteTextView.text.split(separator: "\n")
        if stringComponents.count > 0 {
            noteEntity.setValue(stringComponents[0], forKey: "title")
            stringComponents.remove(at: 0)
            noteEntity.setValue(stringComponents.joined(separator: "\n"), forKey: "noteBody")
        } else {
            noteEntity.setValue("", forKey: "title")
            noteEntity.setValue("", forKey: "noteBody")
        }
        
        let time = Double(Date().timeIntervalSince1970)
        noteEntity.setValue(time, forKey: "lastModifiedDate")
        
        if data == nil {
            // save new note
            do {
                try context.save()
                print("note saved")
            } catch {
                print("note save fail")
            }
        } else {
            // update note
            
        }
        
        
    }
}
