//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    var mainViewController: MainSplitViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainViewController = splitViewController as? MainSplitViewController
        mainViewController?.noteTableViewController = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewController?.notes.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? NoteTableViewCell,
              let note = mainViewController?.notes[indexPath.row] else {
            fatalError()
        }
        cell.configureContent(note)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewController?.showNote(position: indexPath.row)
    }
}
