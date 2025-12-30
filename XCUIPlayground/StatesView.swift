//
//  StatesView.swift
//  XCUIPlayground
//
//  Created by Борис Лысиков on 30.12.2025.
//

import SwiftUI

struct StatesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("States")
                    .font(.largeTitle)
                    .padding()
                
                Text("Экран States")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("States")
        }
    }
}

#Preview {
    StatesView()
}
