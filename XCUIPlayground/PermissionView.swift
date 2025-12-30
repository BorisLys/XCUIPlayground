import SwiftUI
import UserNotifications

struct PermissionView: View {
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            List {
                // Ячейка для фото
                NavigationLink(destination: PhotoPermissionView()) {
                    HStack {
                        Image(systemName: "photo")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text(String(localized: "PermissionView.photoCell"))
                            .font(.body)
                    }
                }
                
                // Ячейка для уведомлений
                Section {
                    // Статус
                    HStack {
                        Text(String(localized: "PermissionView.statusTitle"))
                        Spacer()
                        Text(statusText)
                            .foregroundColor(.secondary)
                    }
                    
                    // Кнопка запроса разрешения
                    Button(action: {
                        requestNotificationPermission()
                    }) {
                        Text(String(localized: "PermissionView.requestButton"))
                            .foregroundColor(buttonColor)
                    }
                    .disabled(notificationStatus == .authorized || notificationStatus == .provisional)
                    
                    // Кнопка отправки уведомления
                    if notificationStatus == .authorized || notificationStatus == .provisional {
                        Button(action: {
                            sendTestNotification()
                        }) {
                            Text(String(localized: "PermissionView.sendNotificationButton"))
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Кнопка открытия настроек
                    if notificationStatus == .denied {
                        Button(action: {
                            openSettings()
                        }) {
                            Text(String(localized: "PermissionView.settingsButton"))
                                .foregroundColor(.blue)
                        }
                    }
                } header: {
                    Text(String(localized: "PermissionView.notificationsSection"))
                }
            }
            .navigationTitle(String(localized: "PermissionView.title"))
            .onAppear {
                checkNotificationStatus()
            }
            .alert(String(localized: "PermissionView.alertTitle"), isPresented: $showAlert) {
                Button(String(localized: "AlertView.ok"), role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var statusText: String {
        switch notificationStatus {
        case .notDetermined:
            return String(localized: "PermissionView.statusNotDetermined")
        case .denied:
            return String(localized: "PermissionView.statusDenied")
        case .authorized:
            return String(localized: "PermissionView.statusAuthorized")
        case .provisional:
            return String(localized: "PermissionView.statusProvisional")
        case .ephemeral:
            return String(localized: "PermissionView.statusEphemeral")
        @unknown default:
            return String(localized: "PermissionView.statusUnknown")
        }
    }
    
    private var buttonColor: Color {
        switch notificationStatus {
        case .notDetermined:
            return .blue
        case .denied:
            return .gray
        case .authorized, .provisional:
            return .green
        default:
            return .blue
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
                    alertMessage = String(localized: "PermissionView.errorMessage") + ": \(error.localizedDescription)"
                    showAlert = true
                } else if granted {
                    alertMessage = String(localized: "PermissionView.successMessage")
                    showAlert = true
                } else {
                    alertMessage = String(localized: "PermissionView.deniedMessage")
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
        content.title = String(localized: "PermissionView.notificationTitle")
        content.body = String(localized: "PermissionView.notificationBody")
        content.sound = .default
        content.badge = 1
        
        // Отправка уведомления через 1 секунду
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = String(localized: "PermissionView.notificationError") + ": \(error.localizedDescription)"
                    showAlert = true
                } else {
                    alertMessage = String(localized: "PermissionView.notificationSent")
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    PermissionView()
}

