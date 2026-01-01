import SwiftUI

struct FlowView: View {
    @StateObject private var viewModel = FlowViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: destinationView(for: item.kind)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.body)
                                Text(item.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.title)
        }
    }

    @ViewBuilder
    private func destinationView(for kind: FlowKind) -> some View {
        switch kind {
        case .biometricAuth:
            BiometricAuthView()
        }
    }
}

#Preview {
    FlowView()
}
