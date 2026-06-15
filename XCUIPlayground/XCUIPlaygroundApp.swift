import AppTrackingTransparency
import SwiftUI

@main
struct XCUIPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await ATTrackingManager.requestTrackingAuthorization()
                }
        }
    }
}
