//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    
    var selectedNote: JsonNote?{
        didSet{
            guard let selectedNote = selectedNote else { return }
            configureUIwith(selectedNote)
        }
    }
    
    
    func configureUIwith(_ note: JsonNote) {
        noteTextView.text = note.content
    }
}

