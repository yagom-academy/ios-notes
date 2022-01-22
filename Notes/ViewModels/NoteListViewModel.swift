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

    func fetchNotes() {
        repository.fetchNotes { [weak self] noteList in
            guard let self = self,
                  let noteList = noteList else {
                      return
                  }

            self.noteList = noteList
        }
    }
}
