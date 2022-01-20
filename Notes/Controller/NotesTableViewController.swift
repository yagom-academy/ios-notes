//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = splitViewController as? UITableViewDelegate
        self.tableView.dataSource = splitViewController as? UITableViewDataSource
    }
}
