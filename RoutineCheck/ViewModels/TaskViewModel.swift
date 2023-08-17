import Foundation
import CoreData


class TaskViewModel: ObservableObject {
    @Published public var id: UUID?
    @Published public var name: String?
    @Published public var status: String?
    @Published public var desc: String?
    @Published public var project: Project?
    @Published public var begin_dt: Date?
    @Published public var end_dt: Date?
    @Published public var scheduled_begin_dt: Date?
    @Published public var shceduled_end_dt: Date?
    @Published public var expired_dt: Date?
    @Published public var activities: NSSet?
    @Published public var created_dt: Date?
    @Published public var updated_dt: Date?
    
#if DEBUG
    private let viewContext = PersistenceController.preview.container.viewContext
#else
    private let viewContext = PersistenceController.shared.container.viewContext
#endif
    
    @Published var tasks : [Task]
    
    init() {
        self.tasks = []
        fetchTasks()
    }
    
    func fetchTasks() {
        fetchTasks(withName: nil, forDate: nil ,project: nil, activity: nil)
    }
    
    func fetchTasks(withName name: String) {
        fetchTasks(withName: name, forDate: nil ,project: nil, activity: nil)
    }
    
    func fetchTasks(forAssignee project: Project) {
        fetchTasks(withName: nil, forDate: nil ,project: project, activity: nil)
    }
    
    func fetchTasks(forDate date: Date) {
        fetchTasks(withName: nil, forDate: date ,project: nil, activity: nil)
    }
    
    func fetchTasks(withName name: String?, forDate: Date? ,project: Project?, activity: Activity?) {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        var predicates = [NSPredicate]()
        
        if let name = name {
            let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", name)
            predicates.append(namePredicate)
        }
        
        if let project = project {
            let assigneePredicate = NSPredicate(format: "assignee == %@", project)
            predicates.append(assigneePredicate)
        }
        
        if let date = forDate {
            var calendar = Calendar.current
            let jtcTimeZone = TimeZone(identifier: "Asia/Tokyo")
            calendar.timeZone = jtcTimeZone!
            
            var component = calendar.dateComponents([.year, .month, .day], from: date)
            component.hour = 0
            component.minute = 0
            component.second = 0
            let start = calendar.date(from:component)
            
            component = calendar.dateComponents([.year, .month, .day], from: date)
            component.hour = 23
            component.minute = 59
            component.second = 59
            let end = calendar.date(from:component)
            let datePredicate = NSPredicate(format:"(scheduled_begin_dt >= %@) AND (scheduled_begin_dt <= %@)",start! as NSDate ,end! as NSDate)
            
            predicates.append(datePredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        
        request.relationshipKeyPathsForPrefetching = ["activities"]
        
        
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Some error occurred while fetching")
        }
    }
    
    func hasTaskForDate(_ date: Date) -> Bool {
        let tasks = fetchTasksForCalendar(date)
        return !tasks.isEmpty
    }
    
    private func fetchTasksForCalendar(_ date: Date) -> [Task] {
        let request = NSFetchRequest<Task>(entityName: "Task")
        var predicates = [NSPredicate]()
        var calendar = Calendar.current
        let jtcTimeZone = TimeZone(identifier: "Asia/Tokyo")
        calendar.timeZone = jtcTimeZone!
        
        var component = calendar.dateComponents([.year, .month, .day], from: date)
        component.hour = 0
        component.minute = 0
        component.second = 0
        let start = calendar.date(from:component)
        
        component = calendar.dateComponents([.year, .month, .day], from: date)
        component.hour = 23
        component.minute = 59
        component.second = 59
        let end = calendar.date(from:component)
        let datePredicate = NSPredicate(format:"(scheduled_begin_dt >= %@) AND (scheduled_begin_dt <= %@)",start! as NSDate ,end! as NSDate)
        predicates.append(datePredicate)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        
        do {
            let tasks = try viewContext.fetch(request)
            return tasks
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func expiredTasksToAbondone() -> Int {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        let expiredTaskPredicates = NSPredicate(format: "status == %@ AND expired_dt < %@", "scheduled", NSDate())
        
        request.predicate = expiredTaskPredicates
        
        do {
            let tasksToUpdate = try viewContext.fetch(request)
            for task in tasksToUpdate {
                task.status = "abandoned"
            }
            try viewContext.save()
            let expiredTaskCount = tasksToUpdate.count
            return expiredTaskCount
        } catch {
            print("Error updating tasks: \(error.localizedDescription)")
        }
        return 0
    }
    
    
    var firstTask: Task? {
        return tasks.first
    }
    
    func numberOfActivities(for task: Task) -> Int {
        return task.activities?.count ?? 0
    }
    
    func createTask (
        name: String,
        desc: String,
        status: String,
        scheduled_begin_dt: Date,
        scheduled_end_dt: Date,
        expired_dt: Date,
        project: Project?,
        bulkTaskCount: Int,
        bulkInterval: Int
    ){
        var intervalComponents: Calendar.Component
        
        let calendar = Calendar.current
        
        for index in 0..<bulkTaskCount + 1 {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.name = name
            newTask.desc = desc
            if index == 0 {
                newTask.status = status
            } else {
                newTask.status = "scheduled"
            }
            
            print(bulkInterval)
            switch bulkInterval {
            case 1:
                intervalComponents = .day
            case 2:
                intervalComponents = .weekOfYear
            case 3:
                intervalComponents = .month
            default:
                intervalComponents = .day
            }
            newTask.scheduled_begin_dt = calendar.date(byAdding: intervalComponents, value: index + 1, to: scheduled_begin_dt)!
            newTask.scheduled_end_dt = calendar.date(byAdding: intervalComponents,value: index + 1, to: scheduled_end_dt)!
            newTask.expired_dt = calendar.date(byAdding: intervalComponents,value: index + 1, to: expired_dt)!
            newTask.created_dt = Date()
            newTask.updated_dt = Date()
            if let projectToAssociate = project {
                newTask.project = projectToAssociate
                project?.addToTasks(newTask)
            }
            viewContext.insert(newTask)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        fetchTasks()
        ProjectViewModel().fetchProjects()
        
    }
    
    func updateTask (
        uuid: UUID,
        name: String,
        desc: String,
        status: String,
        scheduled_begin_dt: Date,
        scheduled_end_dt: Date,
        expired_dt: Date
    ){
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            let fetchedTasks = try viewContext.fetch(fetchRequest)
            if let targetTask = fetchedTasks.first {
                targetTask.name = name
                targetTask.desc = desc
                targetTask.scheduled_begin_dt = scheduled_begin_dt
                targetTask.scheduled_begin_dt = scheduled_end_dt
                targetTask.expired_dt = expired_dt
                targetTask.status = status
                targetTask.updated_dt = Date()
            }
            try viewContext.save()
            fetchTasks()
            ProjectViewModel().fetchProjects()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        do {
            try viewContext.save()
            fetchTasks()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
    func deleteTaskWithRelatedItems(_ task: Task) {
        if let activities = task.activities?.allObjects as? [Activity] {
            for activity in activities {
                viewContext.delete(activity)
            }
        }
        
        viewContext.delete(task)
        do {
            try viewContext.save()
            fetchTasks()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
}

