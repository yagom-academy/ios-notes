//
//  NoteRepositoryImpl.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import Foundation
import CoreData

struct NoteRepositoryImpl: NoteRepository {

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()

    func notes(completion: @escaping ([Note]?) -> Void) {
        let context = persistentContainer.viewContext
        DispatchQueue.global().async {
            do {
                let noteEntities = try context.fetch(request)
                let noteList: [Note] = noteEntities.map { noteEntity in
                    Note(
                        id: noteEntity.id?.uuidString,
                        title: noteEntity.title,
                        contents: noteEntity.contents,
                        date: "temp"
                    )
                }
                completion(noteList)
            } catch {
                fatalError("(\(#function) is error")
            }
        }
    }

    func note(completioin: @escaping (Note?) -> Void, id: String?) {

    }

    func addOrUpdateNote() {
        let context = persistentContainer.viewContext
        let noteEntity = NoteEntity(context: context)
        noteEntity.id = UUID()
        print(noteEntity)
    }

    func deleteNote() {
        print("ok")
    }
}
