//
//  ComponentDetailView.swift
//  XCUIPlayground
//
//  Created by Борис Лысиков on 30.12.2025.
//

import SwiftUI

struct ComponentDetailView: View {
    let componentName: String
    
    var body: some View {
        VStack {
            Text(componentName)
                .font(.largeTitle)
                .padding()
            
            Text("Детали компонента")
                .foregroundColor(.secondary)
        }
        .navigationTitle(componentName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ComponentDetailView(componentName: "Кнопка")
    }
}
