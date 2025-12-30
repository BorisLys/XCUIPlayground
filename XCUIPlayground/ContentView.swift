import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ComponentsView()
                .tabItem {
                    Label(String(localized: "ContentView.componentsTab"), systemImage: "square.grid.2x2")
                }
            
            FlowView()
                .tabItem {
                    Label(String(localized: "ContentView.flowTab"), systemImage: "arrow.triangle.branch")
                }
            
            PermissionView()
                .tabItem {
                    Label(String(localized: "ContentView.permissionTab"), systemImage: "lock.shield")
                }
        }
    }
}

#Preview {
    ContentView()
}
