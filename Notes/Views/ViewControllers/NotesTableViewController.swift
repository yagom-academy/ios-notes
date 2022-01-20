//
//  Notes - NotesTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NotesTableViewController: UITableViewController {

    @IBOutlet var noteTableView: UITableView!
    
    var noteListViewModel = NoteListViewModel()
    private var noteList: [Note]?
    private var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewModel()
        self.noteListViewModel.notes()
    }

    private func setViewModel() {
        self.noteListViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.noteList = self.noteListViewModel.noteList
            self.noteTableView.reloadData()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.selectedNote = nil
        self.performSegue(withIdentifier: Constant.noteDetailSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? NoteViewController
        destinationViewController?.noteTableViewController = self
        destinationViewController?.note = self.selectedNote
    }
}

extension NotesTableViewController {
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedNote = noteList?[indexPath.row]
        self.performSegue(withIdentifier: Constant.noteDetailSegue, sender: self)
    }
}

extension NotesTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NoteTableViewCell else {
            return UITableViewCell()
        }

        guard let noteList = self.noteList else {
            return cell
        }

        cell.titleLabel.text = noteList[indexPath.row].title
        cell.shortDescriptionLabel.text = noteList[indexPath.row].contents

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        cell.dateLabel.text = dateFormatter.string(from: noteList[indexPath.row].date)

        return cell
    }
}