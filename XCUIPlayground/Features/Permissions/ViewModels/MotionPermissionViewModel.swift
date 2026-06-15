import Combine
import CoreMotion
import SwiftUI

final class MotionPermissionViewModel: ObservableObject {
    @Published var authorizationStatus: CMAuthorizationStatus = .notDetermined
    @Published var stepCount: Int?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool { authorizationStatus == .authorized }
    var isDenied: Bool { authorizationStatus == .denied || authorizationStatus == .restricted }

    private let pedometer = CMPedometer()

    func checkStatus() {
        authorizationStatus = CMMotionActivityManager.authorizationStatus()
    }

    func requestAndFetchSteps() {
        isLoading = true
        let start = Calendar.current.startOfDay(for: Date())
        pedometer.queryPedometerData(from: start, to: Date()) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error {
                    self?.alertMessage = String(localized: "MotionPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                } else if let data {
                    self?.stepCount = data.numberOfSteps.intValue
                }
                self?.checkStatus()
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
