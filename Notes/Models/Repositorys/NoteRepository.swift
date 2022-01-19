//
//  NoteRepository.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation

protocol NoteRepository {
    func notes(completion: @escaping ([Note]?) -> Void)
    func note(completioin: @escaping (Note?) -> Void, id: String?)
    func addOrUpdateNote()
    func deleteNote()
}
