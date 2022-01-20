//
//  UserNotes+CoreDataProperties.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//
//

import Foundation
import CoreData


extension UserNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserNotes> {
        return NSFetchRequest<UserNotes>(entityName: "UserNotes")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var noteBody: String?
    @NSManaged public var lastModifiedDate: String?

}

extension UserNotes : Identifiable {

}
