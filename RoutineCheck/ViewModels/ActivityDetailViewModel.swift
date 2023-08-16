import Foundation
import CoreData

class ActivityDetailViewModel: ObservableObject {
    @Published var activity: Activity
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    init(activity: Activity) {
        self.activity = activity
    }
}

