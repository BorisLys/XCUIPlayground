import SwiftUI
import Combine

enum FieldState: String {
    case idle = "idle"
    case editing = "editing"
    case valid = "valid"
    case invalid = "invalid"
    case loading = "loading"
    case success = "success"
    case error = "error"
    case empty = "empty"
    case results = "results"
}

final class InputFieldViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailState: FieldState = .idle
    @Published var emailError: String = ""

    @Published var phone: String = ""
    @Published var phoneState: FieldState = .idle

    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var passwordState: FieldState = .idle

    @Published var showSuccess: Bool = false

    var isFormValid: Bool {
        emailState == .valid &&
        phoneState == .valid &&
        passwordState == .valid
    }

    func handleEmailChange(_ value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespaces).lowercased()
        if trimmed != value {
            email = trimmed
            return
        }

        if value.isEmpty {
            emailState = .idle
            emailError = ""
        } else if value.contains(where: { $0.isWhitespace }) {
            emailState = .editing
            emailError = ""
        } else {
            emailState = .editing
            validateEmail(value)
        }
    }

    func handlePhoneChange(_ value: String) {
        let digitsOnly = value.filter { $0.isNumber }

        let formatted = formatPhone(value)
        if formatted != value {
            phone = formatted
            let formattedDigits = formatted.filter { $0.isNumber }
            updatePhoneState(digits: formattedDigits)
            return
        }

        updatePhoneState(digits: digitsOnly)
    }

    func handlePasswordChange(_ value: String) {
        if value.isEmpty {
            passwordState = .idle
        } else if value.count >= 8 {
            passwordState = .valid
        } else {
            passwordState = .invalid
        }
    }

    func continueTapped() {
        if isFormValid {
            showSuccess = true
        }
    }

    func borderColor(for state: FieldState) -> Color {
        switch state {
        case .valid: return .green
        case .invalid: return .red
        case .editing: return .blue
        default: return .clear
        }
    }

    func normalizePhone(_ formatted: String) -> String {
        let digits = formatted.filter { $0.isNumber }
        if digits.hasPrefix("7") {
            return "+" + digits
        } else if digits.hasPrefix("8") {
            return "+7" + String(digits.dropFirst())
        } else {
            return "+7" + digits
        }
    }

    private func validateEmail(_ value: String) {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if predicate.evaluate(with: value) {
            emailState = .valid
            emailError = ""
        } else {
            emailState = .invalid
            emailError = String(localized: "InputFieldView.emailInvalid")
        }
    }

    private func updatePhoneState(digits: String) {
        if digits.isEmpty {
            phoneState = .idle
        } else {
            let normalizedDigits = normalizePhoneDigits(digits)
            if normalizedDigits.count == 11 && normalizedDigits.hasPrefix("7") {
                phoneState = .valid
            } else if digits.count > 0 {
                phoneState = .editing
            } else {
                phoneState = .idle
            }
        }
    }

    private func normalizePhoneDigits(_ digits: String) -> String {
        if digits.hasPrefix("8") {
            return "7" + String(digits.dropFirst())
        } else if digits.hasPrefix("7") {
            return digits
        } else {
            return "7" + digits
        }
    }

    private func formatPhone(_ value: String) -> String {
        let digits = value.filter { $0.isNumber }

        if digits.isEmpty { return "" }

        var formatted = "+7"
        if digits.hasPrefix("7") {
            let withoutPrefix = String(digits.dropFirst())
            formatted = formatPhoneDigits(withoutPrefix)
        } else if digits.hasPrefix("8") {
            let withoutPrefix = String(digits.dropFirst())
            formatted = formatPhoneDigits(withoutPrefix)
        } else {
            formatted = formatPhoneDigits(digits)
        }

        return formatted
    }

    private func formatPhoneDigits(_ digits: String) -> String {
        var result = "+7"
        let digitsArray = Array(digits)

        if digitsArray.count > 0 {
            result += " ("
            let start = min(3, digitsArray.count)
            result += String(digitsArray[0..<start])

            if digitsArray.count > 3 {
                result += ") "
                let midStart = 3
                let midEnd = min(6, digitsArray.count)
                result += String(digitsArray[midStart..<midEnd])

                if digitsArray.count > 6 {
                    result += "-"
                    let endStart = 6
                    let endEnd = min(8, digitsArray.count)
                    result += String(digitsArray[endStart..<endEnd])

                    if digitsArray.count > 8 {
                        result += "-"
                        result += String(digitsArray[8..<min(10, digitsArray.count)])
                    }
                }
            }
        }

        return result
    }
}
