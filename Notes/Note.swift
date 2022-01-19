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

    init(title: String, body: String, date: Double) {
        self.title = title
        self.body = body
        self.date = Date(timeIntervalSince1970: date)
    }
}
