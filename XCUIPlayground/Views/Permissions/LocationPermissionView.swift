import SwiftUI
import MapKit

struct LocationPermissionView: View {
    @StateObject private var viewModel = LocationPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Request permission
                if !viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Button {
                            viewModel.requestPermission()
                        } label: {
                            Text(String(localized: "LocationPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.authorizationStatus == .denied ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .accessibilityIdentifier("location_request_permission_button")
                        .disabled(viewModel.authorizationStatus == .denied)

                        if viewModel.authorizationStatus == .notDetermined {
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
                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Button {
                            viewModel.openSettings()
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
                if viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "LocationPermissionView.mapTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)

                        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                            .frame(height: 300)
                            .cornerRadius(12)
                            .accessibilityIdentifier("location_map")

                        HStack(spacing: 12) {
                            Button {
                                viewModel.refreshLocation()
                            } label: {
                                Label("Обновить локацию", systemImage: "location.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("location_refresh_button")

                            Button {
                                viewModel.openInMaps()
                            } label: {
                                Label("Открыть в Картах", systemImage: "map")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("location_open_in_maps_button")
                            .disabled(viewModel.currentLocation == nil)
                        }

                        if let location = viewModel.currentLocation {
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

                    Text("Auth: \(viewModel.authorizationStatus.debugString)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("Error: \(viewModel.lastError ?? "—")")
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
            viewModel.checkPermission()
        }
        .alert(String(localized: "LocationPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationView {
        LocationPermissionView()
    }
}
