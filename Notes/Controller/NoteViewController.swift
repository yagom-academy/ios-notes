//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {
    static let storyboardItentifier: String = "NoteVC"
    
    @IBOutlet private weak var noteTextView: UITextView!
    
    var noteItem: NoteItem? {
        didSet {
            bindNoteItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindNoteItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dissmisVCForNilNoteItem()
    }
    
    private func dissmisVCForNilNoteItem() {
        if noteItem == nil,
           let splitViewController: UISplitViewController = splitViewController,
           splitViewController.isCollapsed {
            let primaryNavController: UINavigationController? = splitViewController.viewControllers.first as? UINavigationController
            primaryNavController?.popViewController(animated: false)
        }
    }
    
    private func bindNoteItem() {
        guard let noteBody = noteItem?.body else {
            noteTextView.text = ""
            return
        }
        noteTextView.text = noteBody
    }
}

extension NoteViewController: NoteSelectionDelegate {
    func noteSelected(_ selectedNote: NoteItem) {
        noteItem = selectedNote
    }
}
