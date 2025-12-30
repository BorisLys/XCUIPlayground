//
//  ContentView.swift
//  XCUIPlayground
//
//  Created by Борис Лысиков on 30.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ComponentsView()
                .tabItem {
                    Label("Components", systemImage: "square.grid.2x2")
                }
            
            FlowView()
                .tabItem {
                    Label("Flow", systemImage: "arrow.triangle.branch")
                }
            
            StatesView()
                .tabItem {
                    Label("States", systemImage: "circle.grid.3x3")
                }
        }
    }
}

#Preview {
    ContentView()
}
