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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if note == nil {
//            saveNote()
//        }
    }
    
    func configureView(data: NoteEntity) {
        self.note = data
    }
    
    func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let data = NoteEntity(context: context)
        data.title = (noteTextView.text).components(separatedBy: CharacterSet.newlines).first
        data.body = noteTextView.text
        data.date = Date()
        do {
            try context.save()
        } catch {
            print("save error")
        }
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in self.deleteNote() })
        
        alertController.addAction(cancel)
        alertController.addAction(delete)
        self.present(alertController, animated: true, completion: nil)
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
        navigationController?.popViewController(animated: true)
    }
    
    func showActivityView() {
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [note?.title, note?.body], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func showAdditionalAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "share..", style: .default, handler: { _ in self.showActivityView()})
        let delete = UIAlertAction(title: "delete", style: .destructive, handler: { _ in self.showDeleteAlert() })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(share)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
