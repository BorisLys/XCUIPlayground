import SwiftUI

struct ToggleView: View {
    @StateObject private var viewModel = ToggleViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 1. Базовый Toggle
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "ToggleView.basicTitle"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Toggle(String(localized: "ToggleView.notificationsLabel"), isOn: $viewModel.isNotificationsEnabled)
                    
                    Text(String(localized: "ToggleView.state") + ": \(viewModel.isNotificationsEnabled ? String(localized: "ToggleView.on") : String(localized: "ToggleView.off"))")
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
                        Toggle(String(localized: "ToggleView.darkModeLabel"), isOn: $viewModel.isDarkModeEnabled)
                    }
                    
                    Text(String(localized: "ToggleView.state") + ": \(viewModel.isDarkModeEnabled ? String(localized: "ToggleView.on") : String(localized: "ToggleView.off"))")
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
                        Toggle(String(localized: "ToggleView.wiFiLabel"), isOn: $viewModel.isWiFiEnabled)
                        
                        Toggle(String(localized: "ToggleView.bluetoothLabel"), isOn: $viewModel.isBluetoothEnabled)
                        
                        Toggle(String(localized: "ToggleView.locationLabel"), isOn: $viewModel.isLocationEnabled)
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
