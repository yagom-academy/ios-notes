//
//  Extension+Date.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import Foundation

extension Date {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY. MM. dd"

        return dateFormatter.string(from: self)
    }
}
