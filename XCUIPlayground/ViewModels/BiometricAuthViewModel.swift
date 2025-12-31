import SwiftUI
import Combine
import LocalAuthentication

enum BiometricAuthState: Hashable {
    case idle
    case success
    case failure
}

final class BiometricAuthViewModel: ObservableObject {
    @Published var state: BiometricAuthState = .idle
    @Published var errorMessage: String?
    @Published var availabilityMessage: String?
    @Published var isBiometryAvailable = false
    @Published var biometryTypeLabel: String?

    func refreshAvailability() {
        let context = LAContext()
        var authError: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)

        isBiometryAvailable = canEvaluate
        availabilityMessage = availabilityMessage(for: authError)
        biometryTypeLabel = biometryLabel(for: context)
    }

    func authenticate() {
        let context = LAContext()
        var authError: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            biometryTypeLabel = biometryLabel(for: context)
            let reason = String(localized: "BiometricAuthView.reason")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.state = .success
                        self?.errorMessage = nil
                    } else {
                        self?.state = .failure
                        self?.errorMessage = error?.localizedDescription
                    }
                }
            }
        }  else {
            state = .failure
            errorMessage = authError?.localizedDescription ?? String(localized: "BiometricAuthView.unavailable")
            availabilityMessage = availabilityMessage(for: authError)
            biometryTypeLabel = String(localized: "BiometricAuthView.biometryUnknown")
        }
    }

    private func availabilityMessage(for error: NSError?) -> String? {
        guard let error, error.domain == LAError.errorDomain else {
            return nil
        }

        let code = LAError.Code(rawValue: error.code)
        switch code {
        case .biometryNotEnrolled:
            return String(localized: "BiometricAuthView.biometryNotEnrolled")
        case .biometryNotAvailable:
            return String(localized: "BiometricAuthView.biometryNotAvailable")
        case .biometryLockout:
            return String(localized: "BiometricAuthView.biometryLockout")
        default:
            return String(localized: "BiometricAuthView.unavailable")
        }
    }

    private func biometryLabel(for context: LAContext) -> String {
        switch context.biometryType {
        case .faceID:
            return String(localized: "BiometricAuthView.biometryFaceID")
        case .touchID:
            return String(localized: "BiometricAuthView.biometryTouchID")
        default:
            return String(localized: "BiometricAuthView.biometryUnknown")
        }
    }
}
