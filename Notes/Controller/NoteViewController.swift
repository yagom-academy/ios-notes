//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    var data: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        noteTextView.adjustsFontForContentSizeCategory = true
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func setData() {
        noteTextView.text = data
    }
}
