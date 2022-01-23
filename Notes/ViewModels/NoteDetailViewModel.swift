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

    func fetchNoteById(id: String?) {
        guard let id = id else { return }

        repository.fetchNoteById(id: id) { [weak self] note in
            guard let self = self else { return }

            self.note = note
        }
    }

    func addNote(note: Note, completion: @escaping () -> Void) {
        repository.addNote(note: note) {
            completion()
        }
    }

    func updateNote(note: Note, completion: @escaping () -> Void) {
        repository.updateNote(note: note) {
            completion()
        }
    }

    func deleteNote(note: Note, completion: @escaping () -> Void) {
        repository.deleteNote(note: note) {
            completion()
        }
    }
}
