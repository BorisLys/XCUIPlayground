import SwiftUI

// MARK: - Input Field View
struct InputFieldView: View {
    @StateObject private var viewModel = InputFieldViewModel()
    
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
            
            TextField(String(localized: "InputFieldView.emailPlaceholder"), text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.borderColor(for: viewModel.emailState), lineWidth: 2)
                )
                .onChange(of: viewModel.email) { oldValue, newValue in
                    viewModel.handleEmailChange(newValue)
                }
            
            if !viewModel.emailError.isEmpty {
                Text(viewModel.emailError)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if viewModel.emailState == .valid {
                Text(String(localized: "InputFieldView.emailValid"))
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(viewModel.emailState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    // MARK: - Phone Field
    private var phoneFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "InputFieldView.phoneLabel"))
                .font(.headline)
            
            TextField(String(localized: "InputFieldView.phonePlaceholder"), text: $viewModel.phone)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.borderColor(for: viewModel.phoneState), lineWidth: 2)
                )
                .onChange(of: viewModel.phone) { oldValue, newValue in
                    viewModel.handlePhoneChange(newValue)
                }
            
            if viewModel.phoneState == .valid {
                Text(String(localized: "InputFieldView.phoneValid"))
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(viewModel.phoneState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if !viewModel.phone.isEmpty {
                Text(String(localized: "InputFieldView.phoneNormalized") + ": \(viewModel.normalizePhone(viewModel.phone))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    // MARK: - Password Field
    private var passwordFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "InputFieldView.passwordLabel"))
                .font(.headline)
            
            HStack {
                if viewModel.isPasswordVisible {
                    TextField(String(localized: "InputFieldView.passwordPlaceholder"), text: $viewModel.password)
                        .textContentType(.password)
                } else {
                    SecureField(String(localized: "InputFieldView.passwordPlaceholder"), text: $viewModel.password)
                        .accessibilityIdentifier("password_input")
                }
                
                Button(action: {
                    viewModel.isPasswordVisible.toggle()
                }) {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.borderColor(for: viewModel.passwordState), lineWidth: 2)
            )
            .onChange(of: viewModel.password) { oldValue, newValue in
                viewModel.handlePasswordChange(newValue)
            }
            
            HStack {
                if viewModel.passwordState == .valid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(String(localized: "InputFieldView.passwordValid"))
                        .font(.caption)
                        .foregroundColor(.green)
                } else if viewModel.passwordState == .invalid && !viewModel.password.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text(String(localized: "InputFieldView.passwordInvalid"))
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            Text(String(localized: "InputFieldView.stateLabel") + ": \(viewModel.passwordState.rawValue)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        Button(action: {
            viewModel.continueTapped()
        }) {
            HStack {
                if viewModel.showSuccess {
                    Image(systemName: "checkmark.circle.fill")
                }
                Text(viewModel.showSuccess ? String(localized: "InputFieldView.success") : String(localized: "InputFieldView.continueButton"))
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(viewModel.showSuccess ? Color.green : (viewModel.isFormValid ? Color.blue : Color.gray))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(!viewModel.isFormValid && !viewModel.showSuccess)
    }
}

#Preview {
    NavigationStack {
        InputFieldView()
            .navigationTitle("Input Fields")
    }
}
