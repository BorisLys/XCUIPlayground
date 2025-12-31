import SwiftUI

struct ComponentsView: View {
    @StateObject private var viewModel = ComponentsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.filteredItems) { item in
                NavigationLink(destination: ComponentDetailView(item: item)) {
                    Text(item.name)
                }
            }
            .navigationTitle(String(localized: "ComponentsView.title"))
            .searchable(text: $viewModel.searchText, prompt: String(localized: "ComponentsView.searchPrompt"))
        }
    }
}

#Preview {
    ComponentsView()
}
