import SwiftUI

struct ToggleView: View {
    @State private var isNotificationsEnabled: Bool = true
    @State private var isDarkModeEnabled: Bool = false
    @State private var isWiFiEnabled: Bool = true
    @State private var isBluetoothEnabled: Bool = false
    @State private var isLocationEnabled: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 1. Базовый Toggle
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ToggleView.basicTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Toggle(String(localized: "ToggleView.notificationsLabel"), isOn: $isNotificationsEnabled)
                    
                    Text(String(localized: "ToggleView.state") + ": \(isNotificationsEnabled ? String(localized: "ToggleView.on") : String(localized: "ToggleView.off"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 2. Toggle с иконкой
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ToggleView.iconTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.blue)
                        Toggle(String(localized: "ToggleView.darkModeLabel"), isOn: $isDarkModeEnabled)
                    }
                    
                    Text(String(localized: "ToggleView.state") + ": \(isDarkModeEnabled ? String(localized: "ToggleView.on") : String(localized: "ToggleView.off"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 3. Несколько Toggle в списке
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ToggleView.multipleTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 16) {
                        Toggle(String(localized: "ToggleView.wiFiLabel"), isOn: $isWiFiEnabled)
                        
                        Toggle(String(localized: "ToggleView.bluetoothLabel"), isOn: $isBluetoothEnabled)
                        
                        Toggle(String(localized: "ToggleView.locationLabel"), isOn: $isLocationEnabled)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationView {
        ToggleView()
            .navigationTitle("Toggle")
    }
}

