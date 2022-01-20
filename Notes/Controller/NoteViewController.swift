//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol NoteViewControllerObserver: NSObject {
    func noteViewControllerDidChange()
    func noteViewControllerDidClickMoreButton(note: NoteEntity)
}

final class NoteViewController: UIViewController {
    @IBOutlet private weak var noteTextView: UITextView?
    var noteEntity: NoteEntity?
    var indexPath: IndexPath?
    weak var delegate: NoteViewControllerObserver?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView?.text = noteEntity?.body
        noteTextView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    // MARK: - Methods
    func updateView() {
        checkHoldView()
        if noteTextView == nil {
            return 
        }
        guard let noteEntity = noteEntity else {
            noteTextView?.text = ""
            return
        }
        noteTextView?.text = (noteEntity.title ?? "") + "\n" + (noteEntity.body ?? "")
    }
    
    func checkHoldView() {
        noteTextView?.isEditable = !(noteEntity == nil)
        noteTextView?.resignFirstResponder()
    }
    
    func saveEntity(by textView: UITextView) {
        var separatedText: [String] = textView.text.components(separatedBy: "\n").map { String($0) }
        noteEntity?.title = separatedText.isEmpty ? nil : separatedText[0]
        if separatedText.isEmpty == false {
            separatedText.removeFirst()
        }
        
        noteEntity?.body = separatedText.joined(separator: "\n")
        noteEntity?.lastModified = Date().timeIntervalSince1970
        NoteCoreDataStorage.shared.saveContext()
    }
    
    @IBAction private func clickMoreButton(_ sender: Any) {
        guard let noteEntity = noteEntity else {
            return
        }
        delegate?.noteViewControllerDidClickMoreButton(note: noteEntity)
    }
}

// MARK: - TextView Delegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        saveEntity(by: textView)
        delegate?.noteViewControllerDidChange()
    }
}
