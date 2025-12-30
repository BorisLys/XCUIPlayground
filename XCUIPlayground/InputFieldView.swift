import SwiftUI

// MARK: - Field States
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

// MARK: - Input Field View
struct InputFieldView: View {
    // Email Field
    @State private var email: String = ""
    @State private var emailState: FieldState = .idle
    @State private var emailError: String = ""
    
    // Phone Field
    @State private var phone: String = ""
    @State private var phoneState: FieldState = .idle
    
    // Password Field
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var passwordState: FieldState = .idle
    
    // Success Message
    @State private var showSuccess: Bool = false
    
    // Continue Button
    private var isFormValid: Bool {
        emailState == .valid &&
        phoneState == .valid &&
        passwordState == .valid
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Email TextField
                emailFieldSection
                
                // Phone TextField
                phoneFieldSection
                
                // Password SecureField
                passwordFieldSection
                
                // Continue Button
                continueButton
            }
            .padding()
        }
    }
    
    // MARK: - Email Field
    private var emailFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "InputFieldView.emailLabel"))
                .font(.headline)
            
            TextField(String(localized: "InputFieldView.emailPlaceholder"), text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor(for: emailState), lineWidth: 2)
                )
                .onChange(of: email) { oldValue, newValue in
                    handleEmailChange(newValue)
                }
            
            if !emailError.isEmpty {
                Text(emailError)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if emailState == .valid {
                Text(String(localized: "InputFieldView.emailValid"))
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(emailState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func handleEmailChange(_ value: String) {
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
    
    private func borderColor(for state: FieldState) -> Color {
        switch state {
        case .valid: return .green
        case .invalid: return .red
        case .editing: return .blue
        default: return .clear
        }
    }
    
    // MARK: - Phone Field
    private var phoneFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "InputFieldView.phoneLabel"))
                .font(.headline)
            
            TextField(String(localized: "InputFieldView.phonePlaceholder"), text: $phone)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor(for: phoneState), lineWidth: 2)
                )
                .onChange(of: phone) { oldValue, newValue in
                    handlePhoneChange(newValue)
                }
            
            if phoneState == .valid {
                Text(String(localized: "InputFieldView.phoneValid"))
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(phoneState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if !phone.isEmpty {
                Text(String(localized: "InputFieldView.phoneNormalized") + ": \(normalizePhone(phone))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func handlePhoneChange(_ value: String) {
        let digitsOnly = value.filter { $0.isNumber }
        
        // Форматируем значение, если нужно
        let formatted = formatPhone(value)
        if formatted != value {
            phone = formatted
            // После форматирования onChange сработает снова, поэтому обновляем состояние на основе отформатированного значения
            let formattedDigits = formatted.filter { $0.isNumber }
            updatePhoneState(digits: formattedDigits)
            return
        }
        
        // Обновляем состояние на основе количества цифр
        updatePhoneState(digits: digitsOnly)
    }
    
    private func updatePhoneState(digits: String) {
        if digits.isEmpty {
            phoneState = .idle
        } else {
            // Проверяем валидность: должно быть 11 цифр, начинаться с 7 или 8
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
    
    private func normalizePhone(_ formatted: String) -> String {
        let digits = formatted.filter { $0.isNumber }
        if digits.hasPrefix("7") {
            return "+" + digits
        } else if digits.hasPrefix("8") {
            return "+7" + String(digits.dropFirst())
        } else {
            return "+7" + digits
        }
    }
    
    // MARK: - Password Field
    private var passwordFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "InputFieldView.passwordLabel"))
                .font(.headline)
            
            HStack {
                if isPasswordVisible {
                    TextField(String(localized: "InputFieldView.passwordPlaceholder"), text: $password)
                        .textContentType(.password)
                } else {
                    SecureField(String(localized: "InputFieldView.passwordPlaceholder"), text: $password)
                        .accessibilityIdentifier("password_input")
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor(for: passwordState), lineWidth: 2)
            )
            .onChange(of: password) { oldValue, newValue in
                handlePasswordChange(newValue)
            }
            
            HStack {
                if passwordState == .valid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(String(localized: "InputFieldView.passwordValid"))
                        .font(.caption)
                        .foregroundColor(.green)
                } else if passwordState == .invalid && !password.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text(String(localized: "InputFieldView.passwordInvalid"))
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(passwordState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func handlePasswordChange(_ value: String) {
        if value.isEmpty {
            passwordState = .idle
        } else if value.count >= 8 {
            passwordState = .valid
        } else {
            passwordState = .invalid
        }
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        Button(action: {
            if isFormValid {
                showSuccess = true
            }
        }) {
            HStack {
                if showSuccess {
                    Image(systemName: "checkmark.circle.fill")
                }
                Text(showSuccess ? String(localized: "InputFieldView.success") : String(localized: "InputFieldView.continueButton"))
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(showSuccess ? Color.green : (isFormValid ? Color.blue : Color.gray))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(!isFormValid && !showSuccess)
    }
}

#Preview {
    NavigationView {
        InputFieldView()
            .navigationTitle("Input Fields")
    }
}

