import SwiftUI

struct PermissionView: View {
    @StateObject private var viewModel = PermissionViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: destinationView(for: item.kind)) {
                        HStack {
                            Image(systemName: item.systemImage)
                                .foregroundColor(item.color)
                                .font(.title2)
                            Text(item.title)
                                .font(.body)
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "PermissionView.title"))
        }
    }

    @ViewBuilder
    private func destinationView(for kind: PermissionKind) -> some View {
        switch kind {
        case .photo:
            PhotoPermissionView()
        case .notifications:
            NotificationPermissionView()
        case .contacts:
            ContactsPermissionView()
        case .location:
            LocationPermissionView()
        }
    }
}

#Preview {
    PermissionView()
}
