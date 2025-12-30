import SwiftUI

struct PermissionView: View {
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
                NavigationLink(destination: NotificationPermissionView()) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.orange)
                            .font(.title2)
                        Text(String(localized: "PermissionView.notificationCell"))
                            .font(.body)
                    }
                }
                
                // Ячейка для геолокации
                NavigationLink(destination: LocationPermissionView()) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text(String(localized: "PermissionView.locationCell"))
                            .font(.body)
                    }
                }
            }
            .navigationTitle(String(localized: "PermissionView.title"))
        }
    }
}

#Preview {
    PermissionView()
}

