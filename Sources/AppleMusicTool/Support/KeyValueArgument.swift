import ArgumentParser

struct KeyValueArgument: ExpressibleByArgument, Decodable {
    let key: String
    let value: String

    init?(argument: String) {
        guard let eq = argument.firstIndex(of: "=") else { return nil }
        let key = String(argument[..<eq])
        let val = String(argument[argument.index(after: eq)...])
        self.key = key
        self.value = val
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        guard let pair = KeyValueArgument(argument: raw) else {
            throw ValidationError("ids must be in key=value form")
        }
        self = pair
    }
}
