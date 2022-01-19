//
//  Note.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import UIKit

struct JsonNote: Decodable {
    let title: String
    let date: Date
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date = "last_modified"
        case content = "body"
    }
    
    static func fectchSampleDate() -> [JsonNote] {
        guard let assetData = NSDataAsset(name: "sample")?.data else {
            fatalError("no data exists")
        }
        let fetchedData = try? JSONDecoder().decode([JsonNote].self, from: assetData)
        return fetchedData ?? []
    }
}
