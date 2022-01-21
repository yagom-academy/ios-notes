//
//  NotesTests.swift
//  NotesTests
//
//  Created by kakao on 2022/01/21.
//

@testable import Notes
import XCTest

class NotesTests: XCTestCase {
    func test_sample_노트_데이터를_asset에서_읽어들여_Note객체로_변환할_수_있다() {
        guard let jsonData: Data = FileLoader.readDataSet(fileName: "sample") else {
            XCTFail("asset read failed")
            return
        }
        
        guard let model: [Note] = JSONParser.decode([Note].self, from: jsonData) else {
            XCTFail("parser failed")
            return
        }
        model.forEach { print($0) }
        XCTAssert(true)
    }
}
