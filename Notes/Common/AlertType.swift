//
//  AlertType.swift
//  Notes
//
//  Created by 이승주 on 2022/01/20.
//

enum AlertType {
    case deleteNote
    case cancel

    var description: String {
        switch self {
        case .deleteNote:
            return Constant.alertdeleteNoteDescription
        case .cancel:
            return Constant.alertCancelDescription
        }
    }
}
