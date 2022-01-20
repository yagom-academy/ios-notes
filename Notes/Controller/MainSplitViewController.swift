//
//  MainSplitViewController.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    // TODO: 데이터 코어데이터로 대체
    lazy var notes: [Note] = {
        var arr = [Note]()
        for num in 0..<10 {
            arr.append(Note(title: "Dummy\(num)", lastModified: Date(), content: "dummy\(num)"))
        }
        return arr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }

    func showNote(position: Int) {
        guard let noteNavigationViewController = storyboard?
                .instantiateViewController(withIdentifier: "NoteNVC") as? UINavigationController,
              let noteViewController = noteNavigationViewController.topViewController as? NoteViewController else {
                  fatalError("StoryboardID mismatch or failed type casting")
        }

        let selectedNote = notes[position]
        noteViewController.note = selectedNote
        showDetailViewController(noteNavigationViewController, sender: nil)
    }
}

extension MainSplitViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? NoteTableViewCell else {
            fatalError()
        }
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.dateLabel.text = DateFormatter.localizedString(from: note.lastModified,
                                                            dateStyle: .long, timeStyle: .none)
        cell.shortDescriptionLabel.text = note.content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNote(position: indexPath.row)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
