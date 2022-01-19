//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    
    var noteModel: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = noteModel?.body
    }
    
    func updateView() {
        noteTextView.text = noteModel?.body
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
}
