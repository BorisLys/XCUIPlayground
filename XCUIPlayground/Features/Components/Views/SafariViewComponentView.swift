import SwiftUI
import SafariServices

struct SafariViewComponentView: View {
    @StateObject private var viewModel = SafariViewComponentViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if let url = viewModel.url {
                SafariView(url: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text(String(localized: "SafariViewComponentView.invalidUrl"))
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding([.top, .horizontal])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ viewController: SFSafariViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        SafariViewComponentView()
            .navigationTitle("SFSafariViewController")
    }
}
