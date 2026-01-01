import SwiftUI
import Combine
import Contacts

final class ContactsPermissionViewModel: ObservableObject {
    private let store = CNContactStore()

    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var contacts: [ContactItem] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var isAuthorized: Bool {
        authorizationStatus == .authorized
    }

    func checkAuthorization() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if isAuthorized {
            fetchContacts()
        }
    }

    func requestAccess() {
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error {
                    self?.alertMessage = String(localized: "ContactsPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self?.showAlert = true
                }
                self?.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
                if granted {
                    self?.fetchContacts()
                }
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func fetchContacts() {
        isLoading = true
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor
        ]

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            var results: [ContactItem] = []
            let request = CNContactFetchRequest(keysToFetch: keys)
            request.sortOrder = .givenName

            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    let name = [contact.givenName, contact.familyName]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                    let phone = contact.phoneNumbers.first?.value.stringValue
                    let email = contact.emailAddresses.first.map { String($0.value) }
                    let details = phone ?? email

                    if !name.isEmpty {
                        results.append(ContactItem(id: contact.identifier, name: name, details: details))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = String(localized: "ContactsPermissionView.errorMessage") + ": \(error.localizedDescription)"
                    self.showAlert = true
                }
            }

            DispatchQueue.main.async {
                self.contacts = results
                self.isLoading = false
            }
        }
    }
}
