import SwiftUI

struct FlowView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(String(localized: "FlowView.title"))
                    .font(.largeTitle)
                    .padding()
                
                Text(String(localized: "FlowView.description"))
                    .foregroundColor(.secondary)
            }
            .navigationTitle(String(localized: "FlowView.title"))
        }
    }
}

#Preview {
    FlowView()
}
