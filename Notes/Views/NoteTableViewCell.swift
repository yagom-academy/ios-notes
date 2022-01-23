//
//  Notes - NoteTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteTableViewCell: UITableViewCell {

    // MARK: - Properties
    // MARK: Reuse Identifier
    static let reuseIdentifier = String(describing: NoteTableViewCell.self)
    
    // MARK: IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var shortDescriptionLabel: UILabel!

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeID)
        }

        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
//        clearContents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        clearContents()
    }
    
    // MARK: Privates
    private func clearContents() {
        titleLabel.text = nil
        dateLabel.text = nil
        shortDescriptionLabel.text = nil
    }

    func updateCell(note: Note) {
        self.titleLabel.text = note.title
        self.shortDescriptionLabel.text = note.contents
        self.dateLabel.text = dateFormatter.string(from: note.date)
    }
}
