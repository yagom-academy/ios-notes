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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContents(with data: UserNotes) {
        titleLabel.text = data.title
        shortDescriptionLabel.text = data.noteBody
        
        guard let localeIdentifier = Locale.preferredLanguages.first else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        
        let date = Date(timeIntervalSince1970: data.lastModifiedDate)
        let stringDate = dateFormatter.string(from: date)
        
        dateLabel.text = stringDate
    }
}
