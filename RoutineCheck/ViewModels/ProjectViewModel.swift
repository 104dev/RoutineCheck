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
    
    func hasRelatedItems(project: Project) -> Bool {
        if let tasks = project.tasks?.allObjects, !tasks.isEmpty {
            return true
        }

        if let activities = project.activities?.allObjects, !activities.isEmpty {
            return true
        }

        return false
    }
    
    func numberOfTasks(for project: Project) -> Int {
        return project.tasks?.count ?? 0
    }

    func numberOfActivities(for project: Project) -> Int {
        return project.activities?.count ?? 0
    }
    
    func storeProject (){
        let newTask = Project(context: viewContext)
        newTask.created_dt = Date()

        do {
            try viewContext.save()
            /*fetchProjects()*/
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteProject(_ project: Project) {
        viewContext.delete(project)
        do {
            try viewContext.save()
            fetchProjects()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
    func deleteWithRelatedItems(_ project: Project) {
        if let tasks = project.tasks?.allObjects as? [Task] {
            for task in tasks {
                viewContext.delete(task)
            }
        }

        if let activities = project.activities?.allObjects as? [Activity] {
            for activity in activities {
                viewContext.delete(activity)
            }
        }

        viewContext.delete(project)
        do {
            try viewContext.save()
            fetchProjects()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
}


