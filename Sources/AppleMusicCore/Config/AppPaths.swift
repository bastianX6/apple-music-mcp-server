import Foundation

public struct AppPaths {
    public let appName: String
    public let defaultConfigPath: String
    public let logsDirectory: String

    public init(appName: String, defaultConfigPath: String, logsDirectory: String) {
        self.appName = appName
        self.defaultConfigPath = defaultConfigPath
        self.logsDirectory = logsDirectory
    }
}
