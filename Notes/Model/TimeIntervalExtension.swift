//
//  TimeIntervalExtension.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//

import Foundation

extension TimeInterval {
    var asDate: Date {
        Date(timeIntervalSince1970: self)
    }
}
