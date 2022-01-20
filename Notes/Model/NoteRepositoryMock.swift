//
//  NoteRepositoryMock.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

struct NoteRepositoryMock: NoteRepositoryType, JSONFileDecodable {

    let decoder: JSONDecoder = JSONDecoder()

    func fetchNoteData(completion: @escaping ([Note]?) -> Void) {
        let jsonFileName = Constant.noteSampleFileName
        DispatchQueue.global().async {
            let response = try? self.decodeJson([Note].self, fileName: jsonFileName)
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}

protocol JSONFileDecodable {
    var decoder: JSONDecoder { get }
}

extension JSONFileDecodable {
    func decodeJson<T: Decodable>(_ decodingType: T.Type, fileName: String) throws -> T? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }

        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try decoder.decode(decodingType, from: jsonData)
        return response
    }
}
