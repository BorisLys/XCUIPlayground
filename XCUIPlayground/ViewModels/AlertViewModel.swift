import SwiftUI
import Combine

final class AlertViewModel: ObservableObject {
    @Published var showBasicAlert = false
    @Published var showTwoButtonAlert = false
    @Published var showDestructiveAlert = false
    @Published var showTextFieldAlert = false
    @Published var alertText: String = ""
    @Published var showToast = false
    @Published var toastMessage: String = ""

    func showTextFieldSavedToast() {
        if !alertText.isEmpty {
            toastMessage = alertText
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.showToast = false
            }
        }
        alertText = ""
    }

    func resetTextField() {
        alertText = ""
    }
}
