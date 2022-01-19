//
//  FileLoader.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation
import UIKit

class FileLoader {
    static let shared: FileLoader = FileLoader()
    
    private init() {}
    
    func readDataSet(fileName: String) -> Data? {
        guard let asset: NSDataAsset = NSDataAsset(name: fileName) else {
            assertionFailure()
            return nil
        }
        return asset.data
    }
}
