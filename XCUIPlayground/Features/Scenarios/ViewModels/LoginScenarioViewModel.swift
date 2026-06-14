import Foundation
import SwiftUI
import Combine

final class LoginScenarioViewModel: ObservableObject {
    private enum Limits {
        static let nameMinLength = 2
        static let nameMaxLength = 40
        static let emailMinLength = 6
        static let emailMaxLength = 64
        static let passwordMinLength = 8
        static let passwordMaxLength = 32
    }

    @Published var mode: LoginScenarioMode = .login
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var state: LoginScenarioState = .idle
    @Published var errorMessage: String?
    @Published var nameValidationMessage: String?
    @Published var emailValidationMessage: String?
    @Published var passwordValidationMessage: String?

    private var registeredUser: LoginScenarioUser?
    private var registeredPassword: String?

    var isAuthenticated: Bool {
        authenticatedUser != nil
    }

    var isLoading: Bool {
        state == .loading
    }

    var canSubmit: Bool {
        guard !isLoading, emailValidationMessage == nil, passwordValidationMessage == nil else {
            return false
        }

        switch mode {
        case .login:
            return hasRequiredLoginFields
        case .registration:
            return nameValidationMessage == nil &&
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            hasRequiredLoginFields
        }
    }

    var submitButtonTitle: String {
        if isLoading {
            return String(localized: "LoginScenarioView.loadingButton")
        }

        switch mode {
        case .login:
            return String(localized: "LoginScenarioView.submitButton")
        case .registration:
            return String(localized: "LoginScenarioView.registerButton")
        }
    }

    private var hasRequiredLoginFields: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    var authenticatedUser: LoginScenarioUser? {
        if case let .authenticated(user) = state {
            return user
        }

        return nil
    }

    func submit() {
        validateAllFields()

        guard canSubmit else {
            return
        }

        switch mode {
        case .login:
            signIn()
        case .registration:
            register()
        }
    }

    func updateMode(_ mode: LoginScenarioMode) {
        self.mode = mode
        errorMessage = nil
        state = .idle
        validateAllFields()
    }

    func handleNameChange(_ value: String) {
        let limitedValue = String(value.prefix(Limits.nameMaxLength))
        if limitedValue != value {
            name = limitedValue
            return
        }

        validateName()
    }

    func handleEmailChange(_ value: String) {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .filter { !$0.isWhitespace }

        let limitedValue = String(normalized.prefix(Limits.emailMaxLength))
        if limitedValue != value {
            email = limitedValue
            return
        }

        validateEmail()
    }

    func handlePasswordChange(_ value: String) {
        let limitedValue = String(value.prefix(Limits.passwordMaxLength))
        if limitedValue != value {
            password = limitedValue
            return
        }

        validatePassword()
    }

    func signIn() {
        guard canSubmit else {
            return
        }

        let submittedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let submittedPassword = password

        state = .loading
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.completeSignIn(email: submittedEmail, password: submittedPassword)
        }
    }

    func register() {
        guard canSubmit else {
            return
        }

        let submittedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let submittedEmail = normalizedEmail
        let submittedPassword = password

        state = .loading
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let user = LoginScenarioUser(name: submittedName, email: submittedEmail)
            self?.registeredUser = user
            self?.registeredPassword = submittedPassword
            self?.state = .authenticated(user)
        }
    }

    func signOut() {
        mode = .login
        name = ""
        email = ""
        password = ""
        isPasswordVisible = false
        errorMessage = nil
        nameValidationMessage = nil
        emailValidationMessage = nil
        passwordValidationMessage = nil
        state = .idle
    }

    private func completeSignIn(email: String, password: String) {
        if email == LoginScenarioCredentials.email && password == LoginScenarioCredentials.password {
            state = .authenticated(LoginScenarioCredentials.user)
        } else if let registeredUser, email == registeredUser.email, password == registeredPassword {
            state = .authenticated(registeredUser)
        } else {
            state = .failed
            errorMessage = String(localized: "LoginScenarioView.invalidCredentials")
        }
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func validateAllFields() {
        if mode == .registration {
            validateName()
        } else {
            nameValidationMessage = nil
        }

        validateEmail()
        validatePassword()
    }

    private func validateName() {
        guard mode == .registration else {
            nameValidationMessage = nil
            return
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedName.isEmpty {
            nameValidationMessage = nil
        } else if trimmedName.count < Limits.nameMinLength {
            nameValidationMessage = String(localized: "LoginScenarioView.nameTooShort")
        } else {
            nameValidationMessage = nil
        }
    }

    private func validateEmail() {
        let value = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if value.isEmpty {
            emailValidationMessage = nil
        } else if value.count < Limits.emailMinLength {
            emailValidationMessage = String(localized: "LoginScenarioView.emailTooShort")
        } else if value.count > Limits.emailMaxLength {
            emailValidationMessage = String(localized: "LoginScenarioView.emailTooLong")
        } else if !isValidEmail(value) {
            emailValidationMessage = String(localized: "LoginScenarioView.emailInvalidFormat")
        } else {
            emailValidationMessage = nil
        }
    }

    private func validatePassword() {
        if password.isEmpty {
            passwordValidationMessage = nil
        } else if password.count < Limits.passwordMinLength {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordTooShort")
        } else if password.count > Limits.passwordMaxLength {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordTooLong")
        } else if password.contains(where: { $0.isWhitespace }) {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordContainsWhitespace")
        } else if !password.contains(where: { $0.isLowercase }) {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordMissingLowercase")
        } else if !password.contains(where: { $0.isUppercase }) {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordMissingUppercase")
        } else if !password.contains(where: { $0.isNumber }) {
            passwordValidationMessage = String(localized: "LoginScenarioView.passwordMissingDigit")
        } else {
            passwordValidationMessage = nil
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: value)
    }
}
