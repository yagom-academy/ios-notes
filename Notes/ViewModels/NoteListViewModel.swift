//
//  NoteListViewModel.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation

class NoteListViewModel {
    private let repository: NoteRepository = NoteRepositoryInjection.injectExpositionRepository()
    var updateView: () -> Void = {}

    var noteList: [Note]? {
        didSet {
            updateView()
        }
    }

    func notes() {
        repository.notes { [weak self] noteList in
            guard let self = self else { return }
            guard let noteList = noteList else {
                return
            }

            self.noteList = noteList
        }
    }
}
