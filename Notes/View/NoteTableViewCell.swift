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
    
    func setContents(with data: UserNotes) {
        titleLabel.text = data.title
        shortDescriptionLabel.text = data.noteBody
        
        guard let localeIdentifier = Locale.preferredLanguages.first else { return }
//        print("-----------------")
//        print(Locale.current.identifier)
//        print(Locale.current.regionCode)
//        print(Locale.current.languageCode)
//        print(Locale.current)
//        print(Locale.preferredLanguages.first)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        
        let date = Date(timeIntervalSince1970: data.lastModifiedDate)
        let stringDate = dateFormatter.string(from: date)
        
        dateLabel.text = stringDate
    }
}
