//
//  Notes - NoteViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet weak var additional: UIBarButtonItem!
    
    private var note: NoteEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note?.body
    }
    
    func configureView(data: NoteEntity) {
        self.note = data
    }
    
    func deleteNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let note = note else { return }
        context.delete(note)
        do {
            try context.save()
        } catch {
            print("delete fail")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showAdditionalAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let handler = { (action: UIAlertAction) in print(action.title) }
//        let deleteAlert = UIAlertAction(title: "진짜요?", style: .destructive, handler: nil)
        let share = UIAlertAction(title: "share..", style: .default, handler: nil)
        let delete = UIAlertAction(title: "delete", style: .destructive, handler: { (action: UIAlertAction) in self.deleteNote() })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(share)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
