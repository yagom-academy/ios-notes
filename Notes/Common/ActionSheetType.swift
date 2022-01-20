//
//  ActionSheetType.swift
//  Notes
//
//  Created by 이승주 on 2022/01/20.
//

enum ActionSheetType {
    case shareNote
    case deleteNote
    case cancel

    var description: String {
        switch self {
        case .shareNote:
            return Constant.actionSheetshareNoteDescription
        case .deleteNote:
            return Constant.actionSheetdeleteNoteDescription
        case .cancel:
            return Constant.actionSheetCancelDescription
        }
    }
}
