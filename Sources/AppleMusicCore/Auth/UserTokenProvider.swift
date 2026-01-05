import Foundation

public struct UserTokenProvider {
    public init() {}

    public func token(using config: AppConfig) -> String? {
        guard let token = config.userToken?.trimmingCharacters(in: .whitespacesAndNewlines), token.isEmpty == false else {
            return nil
        }
        return token
    }
}
