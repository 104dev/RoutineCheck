import Foundation
import CoreData

class ProjectDetailViewModel: ObservableObject {
    @Published var project: Project
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    init(project: Project) {
        self.project = project
    }
}


