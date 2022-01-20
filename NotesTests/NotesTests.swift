//
//  NotesTests.swift
//  NotesTests
//
//  Created by Jinwook Huh on 2022/01/18.
//

import XCTest

class NotesTests: XCTestCase {
    func test_read_json_file_as_data() {
        let jsonData: Data? = FileReader.shared.readFileAsData(fileName: "sample", extensionType: "json")
        XCTAssertNotNil(jsonData)
    }
    
    func test_parse_data_into_note_item() {
        guard let jsonData: Data = FileReader.shared.readFileAsData(fileName: "sample", extensionType: "json") else {
            XCTFail("File read error")
            return
        }
        
        let noteItems: [NoteItem]? = JSONParser.shared.decode([NoteItem].self, from: jsonData)
        XCTAssertNotNil(noteItems)
    }
}
