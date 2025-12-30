import SwiftUI

struct StatesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(String(localized: "StatesView.title"))
                    .font(.largeTitle)
                    .padding()
                
                Text(String(localized: "StatesView.description"))
                    .foregroundColor(.secondary)
            }
            .navigationTitle(String(localized: "StatesView.title"))
        }
    }
}

#Preview {
    StatesView()
}
