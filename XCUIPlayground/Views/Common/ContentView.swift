import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ComponentsView()
                .tabItem {
                    Label(String(localized: "ContentView.componentsTab"), systemImage: "square.grid.2x2")
                }
                .tag(ContentViewModel.Tab.components)
            
            FlowView()
                .tabItem {
                    Label(String(localized: "ContentView.flowTab"), systemImage: "arrow.triangle.branch")
                }
                .tag(ContentViewModel.Tab.flow)
            
            PermissionView()
                .tabItem {
                    Label(String(localized: "ContentView.permissionTab"), systemImage: "lock.shield")
                }
                .tag(ContentViewModel.Tab.permissions)
        }
    }
}

#Preview {
    ContentView()
}
