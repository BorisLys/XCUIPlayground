import SwiftUI

struct StatesView: View {
    @StateObject private var viewModel = StatesViewModel()

    var body: some View {
        NavigationStack {
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
