import SwiftUI
import MapKit
import CoreLocation
import Combine

final class LocationPermissionViewModel: ObservableObject {
    private let locationManager = LocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var currentLocation: CLLocation?
    @Published var lastError: String?
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    init() {
        locationManager.onAuthorizationChange = { [weak self] status in
            self?.authorizationStatus = status
        }
        locationManager.onRegionChange = { [weak self] region in
            self?.region = region
        }
        locationManager.onLocationChange = { [weak self] location in
            self?.currentLocation = location
        }
        locationManager.onErrorChange = { [weak self] error in
            self?.lastError = error
        }
    }

    func checkPermission() {
        authorizationStatus = locationManager.authorizationStatus
        if isAuthorized {
            refreshLocation()
        }
    }

    func requestPermission() {
        locationManager.requestPermission()
    }

    func refreshLocation() {
        locationManager.refreshLocation()
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    func openInMaps() {
        guard let location = currentLocation else {
            alertMessage = "Локация ещё не получена. Подожди пару секунд и попробуй снова."
            showAlert = true
            return
        }

        let coordinate = location.coordinate
        let placemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = "Моё местоположение"

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

    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onRegionChange: ((MKCoordinateRegion) -> Void)?
    var onLocationChange: ((CLLocation?) -> Void)?
    var onErrorChange: ((String?) -> Void)?

    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }

    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func refreshLocation() {
        onErrorChange?(nil)
        manager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onAuthorizationChange?(manager.authorizationStatus)
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            refreshLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onLocationChange?(location)
            self.region.center = location.coordinate
            self.onRegionChange?(self.region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.onErrorChange?(error.localizedDescription)
        }
    }
}

extension CLAuthorizationStatus {
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
