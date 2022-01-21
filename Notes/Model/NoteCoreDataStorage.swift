//
//  NoteCoreData.swift
//  Notes
//
//  Created by kakao on 2022/01/19.
//

import CoreData
import Foundation

class NoteCoreDataStorage {
    static let shared: NoteCoreDataStorage = NoteCoreDataStorage()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores { description, error in
            print(description.url!)
            if let error: Error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func fetch() -> [NoteEntity] {
        let request: NSFetchRequest<NoteEntity> = NSFetchRequest(entityName: "NoteEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        do {
            let notes: [NoteEntity] = try context.fetch(request)
            return notes
        } catch {
            fatalError("there is no Entities")
        }
    }
    
    func insertNewNote() {
        let note: NoteEntity = NoteEntity(context: context)
        note.lastModified = Date().timeIntervalSince1970
        saveContext()
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror: NSError = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(_ object: NoteEntity) {
        context.delete(object)
        saveContext()
    }
}
