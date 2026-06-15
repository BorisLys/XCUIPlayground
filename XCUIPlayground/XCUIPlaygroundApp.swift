import AppTrackingTransparency
import SwiftUI

@main
struct XCUIPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
                    await ATTrackingManager.requestTrackingAuthorization()
                }
        }
    }
}
