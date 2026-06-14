import SwiftUI

struct LoginScenarioView: View {
    @StateObject private var viewModel = LoginScenarioViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let user = viewModel.authenticatedUser {
                    AuthorizedScenarioView(user: user) {
                        viewModel.signOut()
                    }
                } else {
                    headerSection
                    modeSection
                    formSection
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "LoginScenarioView.title"))
        .navigationBarBackButtonHidden(viewModel.isAuthenticated)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "LoginScenarioView.title"))
                .font(.headline)
                .foregroundColor(.primary)

            Text(String(localized: "LoginScenarioView.description"))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }

    private var modeSection: some View {
        Picker(String(localized: "LoginScenarioView.modePickerLabel"), selection: Binding(
            get: { viewModel.mode },
            set: { viewModel.updateMode($0) }
        )) {
            ForEach(LoginScenarioMode.allCases) { mode in
                Text(mode.title).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("login_mode_picker")
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.mode == .registration {
                nameField
            }

            emailField
            passwordField

            if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .accessibilityIdentifier("login_error_label")
            }

            Button {
                viewModel.submit()
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(viewModel.submitButtonTitle)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(viewModel.canSubmit ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!viewModel.canSubmit)
            .accessibilityIdentifier("login_submit_button")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "LoginScenarioView.nameLabel"))
                .font(.headline)

            TextField(String(localized: "LoginScenarioView.namePlaceholder"), text: $viewModel.name)
                .textContentType(.name)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(validationBorder(viewModel.nameValidationMessage))
                .onChange(of: viewModel.name) { oldValue, newValue in
                    viewModel.handleNameChange(newValue)
                }
                .accessibilityIdentifier("login_name_input")

            validationMessage(viewModel.nameValidationMessage, identifier: "login_name_validation_label")
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "LoginScenarioView.emailLabel"))
                .font(.headline)

            TextField(String(localized: "LoginScenarioView.emailPlaceholder"), text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.username)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(validationBorder(viewModel.emailValidationMessage))
                .onChange(of: viewModel.email) { oldValue, newValue in
                    viewModel.handleEmailChange(newValue)
                }
                .accessibilityIdentifier("login_email_input")

            validationMessage(viewModel.emailValidationMessage, identifier: "login_email_validation_label")
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "LoginScenarioView.passwordLabel"))
                .font(.headline)

            HStack {
                if viewModel.isPasswordVisible {
                    TextField(String(localized: "LoginScenarioView.passwordPlaceholder"), text: $viewModel.password)
                        .textContentType(.password)
                        .accessibilityIdentifier("login_password_input")
                } else {
                    SecureField(String(localized: "LoginScenarioView.passwordPlaceholder"), text: $viewModel.password)
                        .textContentType(.password)
                        .accessibilityIdentifier("login_password_input")
                }

                Button {
                    viewModel.isPasswordVisible.toggle()
                } label: {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.blue)
                }
                .accessibilityLabel(String(localized: "LoginScenarioView.togglePasswordVisibility"))
                .accessibilityIdentifier("login_password_visibility_button")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(validationBorder(viewModel.passwordValidationMessage))
            .onChange(of: viewModel.password) { oldValue, newValue in
                viewModel.handlePasswordChange(newValue)
            }

            validationMessage(viewModel.passwordValidationMessage, identifier: "login_password_validation_label")
        }
    }

    private func validationBorder(_ message: String?) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(message == nil ? Color.clear : Color.red, lineWidth: 1)
    }

    @ViewBuilder
    private func validationMessage(_ message: String?, identifier: String) -> some View {
        if let message, !message.isEmpty {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .accessibilityIdentifier(identifier)
        }
    }
}

private struct AuthorizedScenarioView: View {
    let user: LoginScenarioUser
    let onSignOut: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text(String(localized: "LoginScenarioView.successTitle"))
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityIdentifier("login_success_title")

            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized: "LoginScenarioView.statusAuthenticated"))
                    .font(.body)
                    .foregroundColor(.green)

                Text(user.name)
                    .font(.headline)

                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button {
                onSignOut()
            } label: {
                Text(String(localized: "LoginScenarioView.logoutButton"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityIdentifier("login_logout_button")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        LoginScenarioView()
    }
}
