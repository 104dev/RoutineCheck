import Foundation
import CoreData

class TaskDetailViewModel: ObservableObject {
    @Published var task: Task
    private let viewContext = PersistenceController.preview.container.viewContext

    init(task: Task) {
        self.task = task
    }    
}
