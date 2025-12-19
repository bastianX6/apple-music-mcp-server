import Foundation

/// Utility to extract the next offset from an Apple Music `next` URL.
struct PaginationParser {
    static func nextOffset(from data: Data) -> Int? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let meta = json["meta"] as? [String: Any],
              let next = meta["next"] as? String,
              let components = URLComponents(string: next),
              let offsetItem = components.queryItems?.first(where: { $0.name == "offset" }),
              let value = offsetItem.value,
              let offset = Int(value) else {
            return nil
        }
        return offset
    }
}
