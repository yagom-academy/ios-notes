//
//  Notes - NoteViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextView: UITextView!
    var data: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.adjustsFontForContentSizeCategory = true
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self)
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noteTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    private func setData() {
        noteTextView.text = data
    }
    
    func reload() {
        setData()
    }
}
