import SwiftUI

struct ComponentsView: View {
    @StateObject private var viewModel = ComponentsViewModel()
    @State private var selectedItem: ComponentItem?
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredItems) { item in
                Button {
                    selectedItem = item
                } label: {
                    Text(item.name)
                }
            }
            .navigationTitle(String(localized: "ComponentsView.title"))
            .searchable(text: $viewModel.searchText, prompt: String(localized: "ComponentsView.searchPrompt"))
            .fullScreenCover(item: $selectedItem) { item in
                NavigationStack {
                    ComponentDetailView(item: item)
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
}

#Preview {
    ComponentsView()
}
