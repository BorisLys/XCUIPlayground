import SwiftUI
import WebKit

struct WebViewComponentView: View {
    @StateObject private var viewModel = WebViewComponentViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if let url = viewModel.url {
                WebViewContainer(url: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text(String(localized: "WebViewComponentView.invalidUrl"))
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding([.top, .horizontal])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}

private struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}

#Preview {
    NavigationStack {
        WebViewComponentView()
            .navigationTitle("WKWebView")
    }
}
