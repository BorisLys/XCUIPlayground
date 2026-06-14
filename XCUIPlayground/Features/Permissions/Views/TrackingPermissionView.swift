import SwiftUI

struct TrackingPermissionView: View {
    @StateObject private var viewModel = TrackingPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.trackingStatus == .notDetermined {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "TrackingPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(String(localized: "TrackingPermissionView.requestDescription"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button {
                            viewModel.requestPermission()
                        } label: {
                            Text(String(localized: "TrackingPermissionView.requestButton"))
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

                if viewModel.isDenied {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "TrackingPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.openSettings()
                        } label: {
                            Text(String(localized: "TrackingPermissionView.settingsButton"))
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

                if viewModel.trackingStatus != .notDetermined {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "TrackingPermissionView.statusTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        HStack(spacing: 12) {
                            Image(systemName: "app.badge.checkmark")
                                .foregroundColor(.indigo)
                                .font(.title2)
                            Text(viewModel.statusDescription)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                        Text(String(localized: "TrackingPermissionView.oneShotNote"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "TrackingPermissionView.title"))
        .onAppear {
            viewModel.checkStatus()
        }
        .alert(String(localized: "TrackingPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        TrackingPermissionView()
    }
}
