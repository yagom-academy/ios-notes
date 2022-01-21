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
    private let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    private let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()

    func notes(completion: @escaping ([Note]?) -> Void) {
        let context = persistentContainer.viewContext
        DispatchQueue.global().async {
            do {
                let noteEntities = try context.fetch(request)
                let noteList: [Note] = noteEntities.map { noteEntity in
                    Note(
                        id: noteEntity.id?.uuidString ?? "",
                        title: noteEntity.title ?? "",
                        contents: noteEntity.contents ?? "",
                        entireContents: noteEntity.entireContents ?? "",
                        date: noteEntity.date ?? Date()
                    )
                }
                completion(noteList)
            } catch {
                fatalError("(\(#function) is error")
            }
        }
    }

    func note(id: String?, completion: @escaping (Note?) -> Void) {
        let context = persistentContainer.viewContext
        DispatchQueue.global().async {
            do {
                let noteEntities = try context.fetch(request)
                let noteList: [Note] = noteEntities
                    .filter { noteEntity in
                        return noteEntity.id?.uuidString == id
                    }
                    .map { noteEntity in
                        Note(
                            id: noteEntity.id?.uuidString ?? "",
                            title: noteEntity.title ?? "",
                            contents: noteEntity.contents ?? "",
                            entireContents: noteEntity.entireContents ?? "",
                            date: noteEntity.date ?? Date()
                        )
                    }
                let note = noteList[0]
                completion(note)
            } catch {
                fatalError("(\(#function) is error")
            }
        }
    }

    func addOrUpdateNote(note: Note, completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext

        DispatchQueue.global().async {
            do {
                let noteEntities = try context.fetch(request)
                let noteEntityList: [NoteEntity] = noteEntities
                    .filter { noteEntity in
                        noteEntity.id?.uuidString == note.id
                    }

                let noteCount = noteEntityList.count
                guard noteCount > 0 else {
                    // add
                    let noteEntity = NoteEntity(context: context)
                    noteEntity.id = UUID(uuidString: note.id)
                    noteEntity.title = note.title
                    noteEntity.contents = note.contents
                    noteEntity.entireContents = note.entireContents
                    noteEntity.date = note.date

                    self.saveNotes(completion: completion)
                    return
                }

                // update
                let noteEntity = noteEntityList[0] as NSManagedObject
                noteEntity.setValue(note.title, forKey: "title")
                noteEntity.setValue(note.contents, forKey: "contents")
                noteEntity.setValue(note.entireContents, forKey: "entireContents")
                noteEntity.setValue(note.date, forKey: "date")

                self.saveNotes(completion: completion)
            } catch {
                fatalError("(\(#function) is error")
            }
        }
    }

    func deleteNote(note: Note, completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext

        DispatchQueue.global().async {
            do {
                let noteEntities = try context.fetch(request)
                noteEntities
                    .filter { noteEntity in
                        noteEntity.id?.uuidString == note.id
                    }
                    .map {
                        context.delete($0)
                    }

                self.saveNotes(completion: completion)
            } catch {
                fatalError("(\(#function) is error")
            }
        }
    }

    private func saveNotes(completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext

        do {
            try context.save()
            completion()
        } catch {
            fatalError("cannot save context")
        }
    }
}
