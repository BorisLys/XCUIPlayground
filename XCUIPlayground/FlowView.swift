//
//  FlowView.swift
//  XCUIPlayground
//
//  Created by Борис Лысиков on 30.12.2025.
//

import SwiftUI

struct FlowView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Flow")
                    .font(.largeTitle)
                    .padding()
                
                Text("Экран Flow")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Flow")
        }
    }
}

#Preview {
    FlowView()
}
