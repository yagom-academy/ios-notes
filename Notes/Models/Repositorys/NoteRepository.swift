//
//  NoteRepository.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation

protocol NoteRepository {
    func notes(completion: @escaping ([Note]?) -> Void)
    func note(id: String?, completion: @escaping (Note?) -> Void)
    func addOrUpdateNote(note: Note, completion: @escaping () -> Void)
    func deleteNote(note: Note, completion: @escaping () -> Void)
}
