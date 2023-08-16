import Foundation
import CoreData

class ActivityDetailViewModel: ObservableObject {
    @Published var activity: Activity
    private let viewContext = PersistenceController.preview.container.viewContext

    init(activity: Activity) {
        self.activity = activity
    }
}

