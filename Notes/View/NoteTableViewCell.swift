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
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func clearContents() {
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.shortDescriptionLabel.text = nil
    }
}
