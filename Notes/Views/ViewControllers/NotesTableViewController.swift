//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    @IBOutlet var noteTableView: UITableView!
    private var noteListViewModel = NoteListViewModel()
    private var noteList = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
        noteListViewModel.notes()
    }

    private func setViewModel() {
        self.noteListViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.noteList = self.noteListViewModel.noteList
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NoteTableViewCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = noteList[indexPath.row].title
        cell.shortDescriptionLabel.text = noteList[indexPath.row].contents
        cell.dateLabel.text = noteList[indexPath.row].date

        return cell
    }
}
