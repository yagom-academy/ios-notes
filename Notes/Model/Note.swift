import Foundation

class Note: Decodable {
    var title: String
    var body: String
    var date: Date

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "last_modified"
    }

    init(title: String, body: String, date: Double?) {
        self.title = title
        self.body = body
        if let date: Double = date {
            self.date = Date(timeIntervalSince1970: date)
        } else {
            self.date = Date()
        }
    }
    
    init(note: NoteEntity) {
        self.title = note.title ?? ""
        self.body = note.body ?? ""
        self.date = note.date ?? Date()
    }
    
    func toNoteEntity() -> NoteEntity {
        let noteEntity = NoteEntity()
        noteEntity.title = self.title
        noteEntity.body = self.body
        noteEntity.date = self.date
        return noteEntity
    }
}
