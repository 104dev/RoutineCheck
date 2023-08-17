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
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    
    @Published var projects : [Project]
    
    init() {
        self.projects = []
        fetchProjects()
    }
    
    func fetchProjects() {
        fetchProjects(withName: nil)
    }
    
    func fetchProjects(withName name: String?) {
        let request = NSFetchRequest<Project>(entityName: "Project")
        var predicates = [NSPredicate]()
        if let name = name {
            let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
            predicates.append(namePredicate)
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        
        do {
            projects = try viewContext.fetch(request)
        }catch {
            print("Some error occured while fetching")
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
    
    func createProject (name: String, desc: String){
        let newProject = Project(context: viewContext)
        newProject.id = UUID()
        newProject.name = name
        newProject.desc = desc
        newProject.created_dt = Date()
        do {
            try viewContext.save()
            fetchProjects()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateProject (uuid: UUID, name: String, desc: String) {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            let fetchedProjects = try viewContext.fetch(request)
            if let targetProject = fetchedProjects.first {
                targetProject.name = name
                targetProject.desc = desc
            }
            try viewContext.save()
            fetchProjects()
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


