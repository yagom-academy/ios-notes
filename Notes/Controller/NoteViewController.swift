//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!

    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note
    }
}
