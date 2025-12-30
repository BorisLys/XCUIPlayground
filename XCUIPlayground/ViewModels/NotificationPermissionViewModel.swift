import SwiftUI
import Combine
import UserNotifications

final class NotificationPermissionViewModel: ObservableObject {
    @Published var notificationStatus: UNAuthorizationStatus = .notDetermined
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationStatus = settings.authorizationStatus
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = String(localized: "NotificationPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                } else if granted {
                    self?.alertMessage = String(localized: "NotificationPermissionView.successMessage")
                    self?.showAlert = true
                } else {
                    self?.alertMessage = String(localized: "NotificationPermissionView.deniedMessage")
                    self?.showAlert = true
                }
                self?.checkNotificationStatus()
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "NotificationPermissionView.notificationTitle")
        content.body = String(localized: "NotificationPermissionView.notificationBody")
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = String(localized: "NotificationPermissionView.notificationError") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                } else {
                    self?.alertMessage = String(localized: "NotificationPermissionView.notificationSent")
                    self?.showAlert = true
                }
            }
        }
    }
}
