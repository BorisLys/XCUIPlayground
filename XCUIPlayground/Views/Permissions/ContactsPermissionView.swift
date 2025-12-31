import SwiftUI
import Contacts

struct ContactsPermissionView: View {
    @StateObject private var viewModel = ContactsPermissionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.isAuthorized {
                    requestAccessCard
                }

                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    settingsCard
                }

                if viewModel.isAuthorized {
                    contactsSection
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "ContactsPermissionView.title"))
        .onAppear {
            viewModel.checkAuthorization()
        }
        .alert(String(localized: "ContactsPermissionView.alertTitle"), isPresented: $viewModel.showAlert) {
            Button(String(localized: "AlertView.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var requestAccessCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "ContactsPermissionView.requestTitle"))
                .font(.headline)
                .foregroundColor(.primary)

            Button(action: {
                viewModel.requestAccess()
            }) {
                Text(String(localized: "ContactsPermissionView.requestButton"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.authorizationStatus == .denied ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.authorizationStatus == .denied)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "ContactsPermissionView.settingsTitle"))
                .font(.headline)
                .foregroundColor(.primary)

            Button(action: {
                viewModel.openSettings()
            }) {
                Text(String(localized: "ContactsPermissionView.settingsButton"))
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

    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String(localized: "ContactsPermissionView.contactsTitle"))
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(String(localized: "ContactsPermissionView.contactsCount") + ": \(viewModel.contacts.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if viewModel.isLoading {
                ProgressView(String(localized: "ContactsPermissionView.loading"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if viewModel.contacts.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(localized: "ContactsPermissionView.emptyTitle"))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text(String(localized: "ContactsPermissionView.emptyMessage"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.contacts) { contact in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.teal)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.name)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                if let details = contact.details {
                                    Text(details)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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

#Preview {
    NavigationView {
        ContactsPermissionView()
    }
}
