import SwiftUI

@main
struct RoutineCheckApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

