//
//  NoteRepositoryProtocol.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

protocol NoteRepositoryType {
    func fetchNoteData(completion: @escaping ([Note]?) -> Void)
}
