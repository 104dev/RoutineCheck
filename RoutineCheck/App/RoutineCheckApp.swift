import SwiftUI

@main
struct RoutineCheckApp: App {
    #if RELEASE
    let persistenceController = PersistenceController.shared
    #endif
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

