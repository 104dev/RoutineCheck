import Foundation
import CoreData

class Seeder {
    static func seed(in context: NSManagedObjectContext) {
        
        let projectData : [[String: Any]] = [
            [
            "id" : UUID(),
            "name" : "ボディメイキング",
            "desc" : "ボディメイキングを行う",
            "status" : "progressing",
            "created_dt" : Date()
            ]
        ]
        
        let tasksData: [[String: Any]] = [
            [
                "id" : UUID(),
                "name": "トレーニング",
                "desc": "ベンチプレスを行う",
                "status": "scheduled",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 27, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 27, hour: 13, minute: 30)),
                "created_dt" : Date()
            ],
            [
                "id" : UUID(),
                "name": "トレーニング",
                "desc": "ベンチプレスを行う",
                "status": "completed",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 28, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 28, hour: 13, minute: 30)),
                "created_dt" : Date()
            ],
            [
                "id" : UUID(),
                "name": "トレーニング",
                "desc": "ベンチプレスを行う",
                "status": "abandoned",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 29, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 29, hour: 13, minute: 30)),
                "created_dt" : Date()
            ]
        ]
        
        let activitiesData : [[String : Any]] = [
            [
                "id" : UUID(),
                "name": "トレーニングの記録",
                "desc": "ベンチプレスを10回×3セット行った",
                "created_dt" : Date(),
                "updated_dt" : Date()
            ]
        ]
        
        let project = Project(context: context)
        project.id = projectData[0]["id"] as? UUID
        project.name = projectData[0]["name"] as? String
        project.desc = projectData[0]["desc"] as? String
        project.status = projectData[0]["status"] as? String
        project.created_dt = projectData[0]["created_dt"] as? Date
        
        for (n, taskSeeder) in tasksData.enumerated() {
            let task = Task(context: context)
            task.id = UUID()
            task.name = taskSeeder["name"] as? String
            task.desc = taskSeeder["desc"] as? String
            task.status = taskSeeder["status"] as? String
            task.scheduled_begin_dt = taskSeeder["scheduled_begin_dt"] as? Date
            task.scheduled_end_dt = taskSeeder["scheduled_end_dt"] as? Date
            task.created_dt = taskSeeder["created_dt"] as? Date
            task.project = project
            project.addToTasks(task)
            
            if n == 0 {
                for activitySeeder in activitiesData{
                    let activity = Activity(context: context)
                    activity.id = UUID()
                    activity.name = activitySeeder["name"] as? String
                    activity.desc = activitySeeder["desc"] as? String
                    activity.created_dt = activitySeeder["created_dt"] as? Date
                    activity.updated_dt = activitySeeder["updated_dt"] as? Date
                    activity.project = project
                    activity.task = task
                    task.addToActivities(activity)
                    project.addToActivities(activity)
                }
            }
            
        }
                
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

