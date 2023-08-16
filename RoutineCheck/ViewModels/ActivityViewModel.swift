import Foundation
import CoreData

class ActivityViewModel: ObservableObject {
    @Published public var id: UUID?
    @Published public var name: String?
    @Published public var desc: String?
    @Published public var task: Project?
    @Published public var project: Project?
    @Published public var created_dt: Date?
    @Published public var updated_dt: Date?
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    @Published var activities : [Activity]
    
    init() {
        self.activities = []
        fetchActivities()
    }
    
    func fetchActivities() {
        fetchActivities(withName: nil)
    }
    
    func fetchActivities(withName name : String?) {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        var predicates = [NSPredicate]()
        if let name = name {
            let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
            predicates.append(namePredicate)
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        do {
            activities = try viewContext.fetch(request)
        }catch {
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    var firstActibity: Activity? {
        return activities.first
    }
    
    func createActivity (name: String, desc: String, project: Project?, task:Task?){
        let newActivity = Activity(context: viewContext)
        newActivity.id = UUID()
        newActivity.name = name
        newActivity.desc = desc
        newActivity.created_dt = Date()
        if let projectToAssociate = project {
            newActivity.project = projectToAssociate
            project?.addToActivities(newActivity)
        }
        if let taskToAssociate = task {
            newActivity.task = taskToAssociate
            project?.addToActivities(newActivity)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateActivity (uuid: UUID, name: String, desc: String) {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            let fetchedActivities = try viewContext.fetch(fetchRequest)
            if let targetActivity = fetchedActivities.first {
                targetActivity.name = name
                targetActivity.desc = desc
            }
            try viewContext.save()
            fetchActivities()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteActivity(_ activity: Activity) {
        viewContext.delete(activity)
        do {
            try viewContext.save()
            fetchActivities()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
}

