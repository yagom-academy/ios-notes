//
//  Notes - NoteTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: NoteTableViewCell.self)

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var shortDescriptionLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        clearContents()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearContents()
    }

    func configureContent(_ note: Note) {
        titleLabel.text = note.title
        dateLabel.text = DateFormatter.localizedString(from: note.lastModified, dateStyle: .long, timeStyle: .none)
        shortDescriptionLabel.text = note.content
    }

    private func clearContents() {
        titleLabel.text = nil
        dateLabel.text = nil
        shortDescriptionLabel.text = nil
    }
}
