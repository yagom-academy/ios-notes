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
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var shortDescriptionLabel: UILabel?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
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
        titleLabel?.text = nil
        dateLabel?.text = nil
        shortDescriptionLabel?.text = nil
    }
    
    func updateView(by noteModel: NoteEntity) {
        titleLabel?.text = noteModel.title
        dateLabel?.text = dateFormatter.string(from: noteModel.lastModifiedDate)
        shortDescriptionLabel?.text = noteModel.body
    } 
}
