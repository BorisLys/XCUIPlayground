import SwiftUI

struct ComponentsView: View {
    let components = [
        String(localized: "ComponentsView.button"),
        String(localized: "ComponentsView.inputField"),
        String(localized: "ComponentsView.card")
    ]
    
    var body: some View {
        NavigationView {
            List(components, id: \.self) { component in
                NavigationLink(destination: ComponentDetailView(componentName: component)) {
                    Text(component)
                }
            }
            .navigationTitle(String(localized: "ComponentsView.title"))
        }
    }
}

#Preview {
    ComponentsView()
}
