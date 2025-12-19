import Foundation

struct UserTokenProvider {
    func token(using config: AppConfig) -> String? {
        return config.userToken
    }
}
