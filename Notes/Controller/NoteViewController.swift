//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note?.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("TableVC disappeared")
    }
}
