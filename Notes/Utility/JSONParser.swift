//
//  JSONParser.swift
//  Notes
//
//  Created by Jinwook Huh on 2022/01/18.
//

import Foundation

class JSONParser {
    func decode<T: Codable>(_ modelType: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(modelType, from: data)
        } catch {
            assertionFailure("Data decoding failure")
            return nil
        }
    }
}
