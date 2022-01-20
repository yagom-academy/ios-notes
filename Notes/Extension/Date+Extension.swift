//
//  Date+Extension.swift
//  Notes
//
//  Created by Jinwook Huh on 2022/01/20.
//

import Foundation

extension Date {
    func dateString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM. dd"
        return formatter.string(from: self)
    }
}
