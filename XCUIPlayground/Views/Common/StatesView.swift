import SwiftUI

struct StatesView: View {
    @StateObject private var viewModel = StatesViewModel()

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
    StatesView()
}
