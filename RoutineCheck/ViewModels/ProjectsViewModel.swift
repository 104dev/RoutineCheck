import Foundation
import CoreData

class ProjectsViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let viewContext: NSManagedObjectContext
    private let fetchController: NSFetchedResultsController<Project>
    
    var projects: [Project] {
        return fetchController.fetchedObjects ?? []
    }
    
    override init() {
        #if DEBUG
        viewContext = PersistenceController.preview.container.viewContext
        #else
        viewContext = PersistenceController.shared.container.viewContext
        #endif

        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.sortDescriptors = [.init(keyPath: \Project.created_dt, ascending: true)]
        
        fetchController = NSFetchedResultsController<Project>(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        fetchController.delegate = self
        try? fetchController.performFetch()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWillChangeContent is called.")
        objectWillChange.send()
    }
    
}
