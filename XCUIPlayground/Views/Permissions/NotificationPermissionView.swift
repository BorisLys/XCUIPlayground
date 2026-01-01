import SwiftUI

struct NotificationPermissionView: View {
    @StateObject private var viewModel = NotificationPermissionViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Кнопка запроса разрешения
                if viewModel.notificationStatus != .authorized && viewModel.notificationStatus != .provisional {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            viewModel.requestNotificationPermission()
                        }) {
                            Text(String(localized: "NotificationPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.notificationStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.notificationStatus == .denied)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Кнопка открытия настроек
                if viewModel.notificationStatus == .denied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            viewModel.openSettings()
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
                if viewModel.notificationStatus == .authorized || viewModel.notificationStatus == .provisional {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "NotificationPermissionView.sendNotificationTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            viewModel.sendTestNotification()
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
            viewModel.checkNotificationStatus()
        }
        .alert(String(localized: "NotificationPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationPermissionView()
    }
}
