import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Кнопка запроса разрешения
                if notificationStatus != .authorized && notificationStatus != .provisional {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            requestNotificationPermission()
                        }) {
                            Text(String(localized: "NotificationPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(notificationStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(notificationStatus == .denied)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Кнопка открытия настроек
                if notificationStatus == .denied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            openSettings()
                        }) {
                            Text(String(localized: "NotificationPermissionView.settingsButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Кнопка отправки уведомления
                if notificationStatus == .authorized || notificationStatus == .provisional {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.sendNotificationTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            sendTestNotification()
                        }) {
                            Text(String(localized: "NotificationPermissionView.sendNotificationButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "NotificationPermissionView.title"))
        .onAppear {
            checkNotificationStatus()
        }
        .alert(String(localized: "NotificationPermissionView.alertTitle"), isPresented: $showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationStatus = settings.authorizationStatus
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = String(localized: "NotificationPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    showAlert = true
                } else if granted {
                    alertMessage = String(localized: "NotificationPermissionView.successMessage")
                    showAlert = true
                } else {
                    alertMessage = String(localized: "NotificationPermissionView.deniedMessage")
                    showAlert = true
                }
                checkNotificationStatus()
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "NotificationPermissionView.notificationTitle")
        content.body = String(localized: "NotificationPermissionView.notificationBody")
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = String(localized: "NotificationPermissionView.notificationError") + ": \(error.localizedDescription)"
                    showAlert = true
                } else {
                    alertMessage = String(localized: "NotificationPermissionView.notificationSent")
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NotificationPermissionView()
    }
}

