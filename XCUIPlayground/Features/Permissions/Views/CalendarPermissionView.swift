import EventKit
import SwiftUI

struct CalendarPermissionView: View {
    @StateObject private var viewModel = CalendarPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "CalendarPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.requestPermission()
                        } label: {
                            Text(String(localized: "CalendarPermissionView.requestButton"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted
                                        ? Color.gray : Color.blue
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }

                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "CalendarPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.openSettings()
                        } label: {
                            Text(String(localized: "CalendarPermissionView.settingsButton"))
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

                if viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(String(localized: "CalendarPermissionView.eventsTitle"))
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                viewModel.createTestEvent()
                            } label: {
                                Text(String(localized: "CalendarPermissionView.createEventButton"))
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if viewModel.events.isEmpty {
                            Text(String(localized: "CalendarPermissionView.emptyMessage"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(viewModel.events, id: \.eventIdentifier) { event in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(event.title ?? "")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            Text(event.startDate.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "CalendarPermissionView.title"))
        .onAppear {
            viewModel.checkStatus()
            if viewModel.isAuthorized { viewModel.fetchEvents() }
        }
        .alert(String(localized: "CalendarPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        CalendarPermissionView()
    }
}
