import AppTrackingTransparency
import Combine
import SwiftUI

final class TrackingPermissionViewModel: ObservableObject {
    @Published var trackingStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool { trackingStatus == .authorized }
    var isDenied: Bool { trackingStatus == .denied || trackingStatus == .restricted }

    func checkStatus() {
        trackingStatus = ATTrackingManager.trackingAuthorizationStatus
    }

    func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.trackingStatus = status
                switch status {
                case .authorized:
                    self?.alertMessage = String(localized: "TrackingPermissionView.successMessage")
                    self?.showAlert = true
                case .denied, .restricted:
                    self?.alertMessage = String(localized: "TrackingPermissionView.deniedMessage")
                    self?.showAlert = true
                default:
                    break
                }
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    var statusDescription: String {
        switch trackingStatus {
        case .authorized: return String(localized: "TrackingPermissionView.statusAuthorized")
        case .denied: return String(localized: "TrackingPermissionView.statusDenied")
        case .restricted: return String(localized: "TrackingPermissionView.statusRestricted")
        case .notDetermined: return String(localized: "TrackingPermissionView.statusNotDetermined")
        @unknown default: return String(localized: "TrackingPermissionView.statusUnknown")
        }
    }
}
