import Foundation

public extension ConfigLoader {
    static func forApp(paths: AppPaths, overridePath: String?) -> ConfigLoader {
        ConfigLoader(configPath: overridePath, defaultConfigPath: paths.defaultConfigPath)
    }
}
