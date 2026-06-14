import SwiftUI

struct RemindersPermissionView: View {
    @StateObject private var viewModel = RemindersPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "RemindersPermissionView.requestTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.requestPermission()
                        } label: {
                            Text(String(localized: "RemindersPermissionView.requestButton"))
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
                        Text(String(localized: "RemindersPermissionView.settingsTitle"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Button {
                            viewModel.openSettings()
                        } label: {
                            Text(String(localized: "RemindersPermissionView.settingsButton"))
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
                            Text(String(localized: "RemindersPermissionView.remindersTitle"))
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                viewModel.createTestReminder()
                            } label: {
                                Text(String(localized: "RemindersPermissionView.createReminderButton"))
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if viewModel.reminders.isEmpty {
                            Text(String(localized: "RemindersPermissionView.emptyMessage"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(viewModel.reminders, id: \.calendarItemIdentifier) { reminder in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "checklist")
                                            .foregroundColor(.orange)
                                            .font(.title2)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(reminder.title ?? "")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            if let due = reminder.dueDateComponents?.date {
                                                Text(due.formatted(date: .abbreviated, time: .shortened))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
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
        .navigationTitle(String(localized: "RemindersPermissionView.title"))
        .onAppear {
            viewModel.checkStatus()
            if viewModel.isAuthorized { viewModel.fetchReminders() }
        }
        .alert(String(localized: "RemindersPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        RemindersPermissionView()
    }
}
