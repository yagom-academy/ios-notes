//
//  NoteDetailViewModel.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation
import CoreData

class NoteDetailViewModel {
    private let repository: NoteRepository = NoteRepositoryInjection.injectExpositionRepository()
    var updateView: () -> Void = {}

    var note: Note? {
        didSet {
            updateView()
        }
    }

    func note(id: String?) {
        guard let id = id else { return }

        repository.note(id: id) { [weak self] note in
            guard let self = self else { return }

            self.note = note
        }
    }

    func addOrUpdateNote(note: Note, completion: @escaping () -> Void) {
        repository.addOrUpdateNote(note: note) {
            completion()
        }
    }

    func deleteNote(note: Note, completion: @escaping () -> Void) {
        repository.deleteNote(note: note) {
            completion()
        }
    }
}
