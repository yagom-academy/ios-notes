//
//  NoteEntity+CoreDataProperties.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?

}

extension NoteEntity : Identifiable {

}
