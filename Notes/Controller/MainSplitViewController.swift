//
//  MainSplitViewController.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    // TODO: 데이터 코어데이터로 대체
    lazy var notes: [String] = {
        var arr = [String]()
        for num in 0..<10 {
            arr.append("dummy \(num)")
        }
        return arr
    }()
    private var currentPosition: Int?

    private var isCompactWidth: Bool = true
    private var noteViewNavigationController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthStateBySizeClass()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateWidthStateBySizeClass()
        noteViewNavigationController?.dismiss(animated: true, completion: nil)
    }

    func showNote() {
        guard let currentPosition = currentPosition else {
            return
        }

        let selectedNote = notes[currentPosition]
        guard let noteViewController = storyboard?
                .instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController else {
            fatalError("StoryboardID mismatch or type casting failed")
        }
        noteViewController.note = selectedNote
        if isCompactWidth {
            showDetailViewController(noteViewController, sender: nil)
        } else {
            noteViewNavigationController?.popToRootViewController(animated: false)
            noteViewNavigationController?.pushViewController(noteViewController, animated: false)
        }

    }

    func updateWidthStateBySizeClass() {
        let widthSizeClass = self.traitCollection.horizontalSizeClass
        switch widthSizeClass {
        case .compact:
            isCompactWidth = true
        case .regular:
            isCompactWidth = false
            if noteViewNavigationController == nil,
               self.viewControllers.count == 2,
               let secondViewController = self.viewControllers.last as? UINavigationController {
                noteViewNavigationController = secondViewController
            }
            // TODO: 선택된 row가 있으면 메모창을 띄우도록 해야함
        default:
            fatalError("unknown size class")
    }
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
        cell.titleLabel.text = note

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPosition = indexPath.row
        showNote()
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
