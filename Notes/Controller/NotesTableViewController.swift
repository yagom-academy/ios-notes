//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = splitViewController as? MainSplitViewController
        self.tableView.delegate = mainViewController
        self.tableView.dataSource = mainViewController
        mainViewController?.noteTableViewController = self
    }
}
