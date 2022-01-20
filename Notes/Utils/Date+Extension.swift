//
//  Date+Extension.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//

import Foundation

extension Date {
    func toLocalizedString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
}
