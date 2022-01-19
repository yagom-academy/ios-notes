//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    private var note: Note?
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note?.body
    }
    
    func configureView(data: Note) {
        self.note = data
    }
}
