import Foundation

struct AppConfig: Sendable, Codable {
    var teamID: String?
    var musicKitKeyID: String?
    var privateKey: String?
    var privateKeyPath: String?
    var bundleID: String?
    var userToken: String?
}
