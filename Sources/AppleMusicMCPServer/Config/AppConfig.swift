import Foundation

struct AppConfig: Sendable, Codable {
    var teamID: String?
    var musicKitKeyID: String?
    var privateKey: String?
    var userToken: String?
}
