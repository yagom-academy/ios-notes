//
//  CoreDataManager.swift
//  Notes
//
//  Created by kakao on 2022/01/21.
//

import Foundation
import CoreData

class NoteContainerManager {
    private init() { }

    static let shared = NoteContainerManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context = persistentContainer.viewContext

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch() -> [Note] {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let sortBylastModified = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sortBylastModified]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func make() -> Note {
        guard let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as? Note else {
            fatalError("NoteContainerManager: forEntityName mismatched")
        }
        newNote.setValue("새로운 메모", forKey: "title")
        newNote.setValue("내용을 입력해주세요.", forKey: "content")
        newNote.setValue(UUID(), forKey: "id")
        newNote.setValue(Date(), forKey: "lastModified")

        return newNote
    }

    func delete(_ note: Note) {
        context.delete(note)
    }
}
