//
//  Note.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

struct Note: Codable {
    var title: String
    var body: String
    var lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}

func fetchSampleNote() {
    guard let jsonData: Data = FileLoader.readDataSet(fileName: "sample") else {
        return
    }
    
    guard let model: [Note] = JSONParser.decode([Note].self, from: jsonData) else {
        return
    }
    model.forEach {
        print($0.lastModified)
    }
}
