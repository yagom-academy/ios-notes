//
//  NoteDetailViewModel.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation

class NoteDetailViewModel {
    private let repository: NoteRepository = NoteRepositoryInjection.injectExpositionRepository()
    var updateView: () -> Void = {}

    var note: Note? {
        didSet {
            updateView()
        }
    }

    func note(id: String?) {
        repository.note(id: id) { [weak self] note in
            guard let self = self else { return }
            guard let note = note else {
                return
            }

            self.note = note
        }
    }
}
