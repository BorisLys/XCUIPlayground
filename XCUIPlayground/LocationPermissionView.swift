import SwiftUI
import MapKit
import CoreLocation
import Combine

struct LocationPermissionView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Request permission
                if !locationManager.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Button {
                            locationManager.requestPermission()
                        } label: {
                            Text(String(localized: "LocationPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(locationManager.authorizationStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .accessibilityIdentifier("location_request_permission_button")
                        .disabled(locationManager.authorizationStatus == .denied)

                        if locationManager.authorizationStatus == .notDetermined {
                            Text("Совет: лучше запрашивать доступ после понятного объяснения пользователю.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                // MARK: - Open Settings when denied
                if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Button {
                            openSettings()
                        } label: {
                            Text(String(localized: "LocationPermissionView.settingsButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .accessibilityIdentifier("location_open_settings_button")
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                // MARK: - Map + actions
                if locationManager.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.mapTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                            .frame(height: 300)
                            .cornerRadius(12)
                            .accessibilityIdentifier("location_map")

                        HStack(spacing: 12) {
                            Button {
                                locationManager.refreshLocation()
                            } label: {
                                Label("Обновить локацию", systemImage: "location.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("location_refresh_button")

                            Button {
                                openInMaps()
                            } label: {
                                Label("Открыть в Картах", systemImage: "map")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("location_open_in_maps_button")
                            .disabled(locationManager.currentLocation == nil)
                        }

                        if let location = locationManager.currentLocation {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(String(localized: "LocationPermissionView.latitude")): \(String(format: "%.6f", location.coordinate.latitude))")
                                Text("\(String(localized: "LocationPermissionView.longitude")): \(String(format: "%.6f", location.coordinate.longitude))")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .accessibilityIdentifier("location_coords_label")
                        } else {
                            Text("Локация ещё не получена. Нажми «Обновить локацию» или подожди пару секунд.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityIdentifier("location_waiting_label")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                // MARK: - Debug status (полезно для UI-тестов)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Debug")
                        .font(.headline)

                    Text("Auth: \(locationManager.authorizationStatus.debugString)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("Error: \(locationManager.lastError ?? "—")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.15))
                .cornerRadius(12)
                .accessibilityIdentifier("location_debug_panel")
            }
            .padding()
        }
        .navigationTitle(String(localized: "LocationPermissionView.title"))
        .onAppear {
            locationManager.checkPermission()
        }
        .alert(String(localized: "LocationPermissionView.alertTitle"), isPresented: $showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Helpers

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func openInMaps() {
        guard let location = locationManager.currentLocation else {
            alertMessage = "Локация ещё не получена. Подожди пару секунд и попробуй снова."
            showAlert = true
            return
        }

        let coordinate = location.coordinate
        let placemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = "Моё местоположение"

        // Небольшой регион вокруг точки
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let options: [String: Any] = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: span)
        ]

        item.openInMaps(launchOptions: options)
    }
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173), // Москва по умолчанию
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var currentLocation: CLLocation?
    @Published var lastError: String?

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkPermission() {
        authorizationStatus = manager.authorizationStatus
        if isAuthorized {
            refreshLocation()
        }
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func refreshLocation() {
        lastError = nil
        // requestLocation — одноразовый запрос, удобнее для демо и UI-тестов
        manager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if isAuthorized {
            refreshLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            self.region.center = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.lastError = error.localizedDescription
        }
    }
}

private extension CLAuthorizationStatus {
    var debugString: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        @unknown default: return "unknown"
        }
    }
}

#Preview {
    NavigationView {
        LocationPermissionView()
    }
}
