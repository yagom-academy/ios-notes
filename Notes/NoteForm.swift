struct NoteForm: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}
