//
//  FileReader.swift
//  Notes
//
//  Created by Jinwook Huh on 2022/01/18.
//

import Foundation

class FileReader {
    static let shared: FileReader = FileReader()
    
    private init() {}
    
    func readFileAsData(fileName: String, extensionType: String) -> Data? {
        guard let fileUrl: URL = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            assertionFailure()
            return nil
        }
        do {
            let data: Data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            assertionFailure()
            print(error.localizedDescription)
            return nil
        }
    }
}
