import SwiftUI

struct ComponentsView: View {
    @StateObject private var viewModel = ComponentsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                NavigationLink(destination: ComponentDetailView(item: item)) {
                    Text(item.name)
                }
            }
            .navigationTitle(String(localized: "ComponentsView.title"))
        }
    }
}

#Preview {
    ComponentsView()
}
