import SwiftUI

struct BiometricAuthView: View {
    @StateObject private var viewModel = BiometricAuthViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: "BiometricAuthView.title"))
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(String(localized: "BiometricAuthView.description"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6).opacity(0.3))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "BiometricAuthView.statusTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)

                    HStack(spacing: 8) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 10, height: 10)
                        Text(statusText)
                            .font(.body)
                            .foregroundColor(.primary)
                    }

                    if let biometryTypeLabel = viewModel.biometryTypeLabel, !biometryTypeLabel.isEmpty {
                        Text(String(localized: "BiometricAuthView.biometryType") + ": \(biometryTypeLabel)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                        Text(String(localized: "BiometricAuthView.errorTitle") + ": \(errorMessage)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Button(action: {
                    viewModel.authenticate()
                }) {
                    Text(String(localized: "BiometricAuthView.button"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isBiometryAvailable)

                if let availabilityMessage = viewModel.availabilityMessage, !availabilityMessage.isEmpty {
                    Text(availabilityMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "BiometricAuthView.title"))
        .onAppear {
            viewModel.refreshAvailability()
        }
    }

    private var statusText: String {
        switch viewModel.state {
        case .idle:
            return String(localized: "BiometricAuthView.statusIdle")
        case .success:
            return String(localized: "BiometricAuthView.statusSuccess")
        case .failure:
            return String(localized: "BiometricAuthView.statusFailure")
        }
    }

    private var statusColor: Color {
        switch viewModel.state {
        case .idle:
            return .gray
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}

#Preview {
    NavigationStack {
        BiometricAuthView()
    }
}
