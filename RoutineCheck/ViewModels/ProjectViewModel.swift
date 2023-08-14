import Foundation
import CoreData

class ProjectViewModel: ObservableObject {
    @Published public var id: UUID?
    @Published public var name: String?
    @Published public var status: String?
    @Published public var desc: String?
    @Published public var tasks: [Task]?
    @Published public var activities: [Task]?
    @Published public var created_dt: Date?

    private let viewContext = PersistenceController.preview.container.viewContext

    @Published var projects : [Project]
    
    init() {
        self.projects = []
        fetchProjects()
    }
    
    func fetchProjects() {
        let request = NSFetchRequest<Project>(entityName: "Project")
        do {
            projects = try viewContext.fetch(request)
        }catch {
            print("DEBUG: Some error occured while fetching")
        }
    }

    var firstProject: Project? {
        return projects.first
    }
    
    func completedTaskPercentage(for project: Project) -> Double {
        guard let tasks = project.tasks?.allObjects as? [Task], !tasks.isEmpty else { return 0.0 }
        let completedTasks = tasks.filter { ($0).status == "completed" }
        return Double(completedTasks.count) / Double(tasks.count)
    }
    
    func storeProject (viewContext :NSManagedObjectContext){
        let newTask = Project(context: viewContext)
        newTask.created_dt = Date()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
}


