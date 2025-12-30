import SwiftUI

struct FlowView: View {
    @StateObject private var viewModel = FlowViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .padding()
                
                Text(viewModel.descriptionText)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(viewModel.title)
        }
    }
}

#Preview {
    FlowView()
}
