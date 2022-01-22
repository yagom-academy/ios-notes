//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date
    @NSManaged public var title: String

}

extension Note: Identifiable {

}
