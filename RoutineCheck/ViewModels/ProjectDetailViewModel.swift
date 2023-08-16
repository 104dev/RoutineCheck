import Foundation
import CoreData

class ProjectDetailViewModel: ObservableObject {
    @Published var project: Project
    private let viewContext = PersistenceController.preview.container.viewContext

    init(project: Project) {
        self.project = project
    }
}


