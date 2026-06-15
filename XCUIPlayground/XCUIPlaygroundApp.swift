import AppTrackingTransparency
import SwiftUI
import Combine

@main
struct XCUIPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(
                    NotificationCenter.default
                        .publisher(for: UIApplication.didBecomeActiveNotification)
                        .first()
                ) { _ in
                    Task {
                        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
                        await ATTrackingManager.requestTrackingAuthorization()
                    }
                }
        }
    }
}
