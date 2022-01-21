//
//  DateFormatter+extension.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//

import Foundation

extension DateFormatter {
    static let sharedWithLocalizedTemplate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMd")
        return dateFormatter
    }()
}
