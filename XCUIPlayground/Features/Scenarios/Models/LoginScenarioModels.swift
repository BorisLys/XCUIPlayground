import Foundation

enum LoginScenarioState: Hashable {
    case idle
    case loading
    case authenticated(LoginScenarioUser)
    case failed
}

enum LoginScenarioMode: String, CaseIterable, Identifiable {
    case login
    case registration

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .login:
            return String(localized: "LoginScenarioView.modeLogin")
        case .registration:
            return String(localized: "LoginScenarioView.modeRegistration")
        }
    }
}

struct LoginScenarioUser: Hashable {
    let name: String
    let email: String
}

enum LoginScenarioCredentials {
    static let email = "qa@example.com"
    static let password = "Password123"
    static let user = LoginScenarioUser(
        name: String(localized: "LoginScenarioView.testUserName"),
        email: email
    )
}
