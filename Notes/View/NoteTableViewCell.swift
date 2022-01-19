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
    
    func configureCell(data: Note) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy.MM.dd")
        titleLabel.text = data.title
        dateLabel.text = dateFormatter.string(from: data.date)
        shortDescriptionLabel.text = data.body
    }
}
