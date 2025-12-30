//
//  ComponentsView.swift
//  XCUIPlayground
//
//  Created by Борис Лысиков on 30.12.2025.
//

import SwiftUI

struct ComponentsView: View {
    let components = [
        "Кнопка",
        "Поле ввода",
        "Карточка"
    ]
    
    var body: some View {
        NavigationView {
            List(components, id: \.self) { component in
                NavigationLink(destination: ComponentDetailView(componentName: component)) {
                    Text(component)
                }
            }
            .navigationTitle("Components")
        }
    }
}

#Preview {
    ComponentsView()
}
