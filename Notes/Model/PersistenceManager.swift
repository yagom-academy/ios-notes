//
//  PersistenceManager.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//

import Foundation
import CoreData

class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    func fetchNotes(request: NSFetchRequest<Note>) -> [Note] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
//    @discardableResult
//    func updateNote(_ note: Note) -> Bool {
//        let fetchRequest = NSFetchRequest<Not>(entityName: "Note")
//        fetchRequest.predicate = NSPredicate(format: "id = %@", note.id as CVarArg)
//        do {
//            let fetchResult = try context.fetch(fetchRequest)
//            guard let managedObject = fetchResult.first else { return false }
//            managedObject.setValue(note.title, forKey: "title")
//            managedObject.setValue(note.content, forKey: "content")
//            managedObject.setValue(note.date, forKey: "date")
//
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//
//        return true
//    }

    @discardableResult
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func insertNewNote() -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(UUID(), forKey: "id")
        managedObject.setValue("새로운 메모", forKey: "title")
        managedObject.setValue(" ", forKey: "content")
        managedObject.setValue(Date(), forKey: "date")
         
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    private init() {}

}
