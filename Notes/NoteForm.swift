struct NoteForm: Decodable {
    let title: String
    let noteBody: String
    let lastModifiedDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case title
        case noteBody = "body"
        case lastModifiedDate = "last_modified"
    }
}
