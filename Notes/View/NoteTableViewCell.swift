//
//  Notes - NoteTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class NoteTableViewCell: UITableViewCell {
    // MARK: - Properties
    // MARK: Reuse Identifier
    static let reuseIdentifier: String = String(describing: NoteTableViewCell.self)
    
    // MARK: IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        clearContents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearContents()
    }
    
    func bind(item: NoteItem) {
        titleLabel.text = item.title
        dateLabel.text = item.lastModifiedDate.dateString()
        shortDescriptionLabel.text = item.body
    }
    
    // MARK: Privates
    private func clearContents() {
        titleLabel.text = nil
        dateLabel.text = nil
        shortDescriptionLabel.text = nil
    }
}
