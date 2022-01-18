//
//  JSONParser.swift
//  Notes
//
//  Created by Jinwook Huh on 2022/01/18.
//

import Foundation

class JSONParser {
    static let shared: JSONParser = JSONParser()
    
    private init() {}
    
    func decode<T: Codable>(_ modelType: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(modelType, from: data)
        } catch {
//            assertionFailure("Data decoding failure")
            print(error.localizedDescription)
            return nil
        }
    }
}
