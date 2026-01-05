import Foundation

public struct AppConfig: Sendable, Codable {
    public var teamID: String?
    public var musicKitKeyID: String?
    public var privateKey: String?
    public var userToken: String?

    public init(teamID: String? = nil, musicKitKeyID: String? = nil, privateKey: String? = nil, userToken: String? = nil) {
        self.teamID = teamID
        self.musicKitKeyID = musicKitKeyID
        self.privateKey = privateKey
        self.userToken = userToken
    }
}
