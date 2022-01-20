//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    var note: Note? {
        didSet {
            loadViewIfNeeded()
            self.noteTextView.text = note?.content
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

extension NoteViewController: NoteSelcetionDelegate {
    func noteSelected(_ note: Note) {
        self.note = note
    }
}
