import SwiftUI

struct PermissionView: View {
    @StateObject private var viewModel = PermissionViewModel()
    @State private var selectedItem: PermissionItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    Button {
                        selectedItem = item
                    } label: {
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
            .fullScreenCover(item: $selectedItem) { item in
                NavigationStack {
                    destinationView(for: item.kind)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    selectedItem = nil
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        .interactiveDismissDisabled(false)
                }
            }
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
