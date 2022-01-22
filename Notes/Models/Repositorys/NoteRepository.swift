//
//  NoteRepository.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation

protocol NoteRepository {
    func fetchNotes(completion: @escaping ([Note]?) -> Void)
    func fetchNoteById(id: String?, completion: @escaping (Note?) -> Void)
    func addNote(note: Note, completion: @escaping () -> Void)
    func updateNote(note: Note, completion: @escaping () -> Void)
    func deleteNote(note: Note, completion: @escaping () -> Void)
}
