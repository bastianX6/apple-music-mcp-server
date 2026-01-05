import Foundation

struct MusicItemCollection<T: Codable>: Codable {
    var data: [T] = []
}
