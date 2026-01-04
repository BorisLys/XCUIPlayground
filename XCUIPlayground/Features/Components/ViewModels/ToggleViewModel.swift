import SwiftUI
import Combine

final class ToggleViewModel: ObservableObject {
    @Published var isNotificationsEnabled: Bool = true
    @Published var isDarkModeEnabled: Bool = false
    @Published var isWiFiEnabled: Bool = true
    @Published var isBluetoothEnabled: Bool = false
    @Published var isLocationEnabled: Bool = true
}
