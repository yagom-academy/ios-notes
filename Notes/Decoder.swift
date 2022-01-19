import Foundation
import UIKit

struct Decoder {
    static func decodeJSONData<T: Decodable> (type: T.Type, from: String) -> T? {
        guard let items = NSDataAsset.init(name: from) else {
            fatalError("no file")
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: items.data)
        } catch {
            print(error)
        }
        return nil
    }
}
