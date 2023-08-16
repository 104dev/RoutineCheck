import Foundation
import CoreData

class TaskDetailViewModel: ObservableObject {
    @Published var task: Task
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    
    init(task: Task) {
        self.task = task
    }
}
