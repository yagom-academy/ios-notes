//
//  JsonParser.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

struct JSONParser {
    static let shared: JSONParser = JSONParser()
    
    private init() {}
    
    static func decode<T: Codable>(_ modelType: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(modelType, from: data)
        } catch {
            assertionFailure()
            print(error.localizedDescription)
            return nil
        }
    }
}
