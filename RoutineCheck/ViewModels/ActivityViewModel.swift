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

    private let viewContext = PersistenceController.preview.container.viewContext

    @Published var activities : [Activity]
    
    init() {
        self.activities = []
        fetchActivities()
    }
    
    func fetchActivities() {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        do {
            activities = try viewContext.fetch(request)
        }catch {
            print("DEBUG: Some error occured while fetching")
        }
    }

    var firstActibity: Activity? {
        return activities.first
    }

    func createActivity (name: String, desc: String){
        let newActivity = Activity(context: viewContext)
        newActivity.name = name
        newActivity.desc = desc
        newActivity.created_dt = Date()
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
}

