import Foundation
import CoreData

class Seeder {
    static func seed(in context: NSManagedObjectContext) {
        
        let projectData : [[String: Any]] = [
            [
            "id" : UUID(),
            "name" : "ボディメイク",
            "desc" : "・筋トレを継続してカラダを大きくする。\n・引き締まったボディを目指す。",
            "created_dt" : Date()
            ]
        ]
        
        let tasksData: [[String: Any]] = [
            [
                "id" : UUID(),
                "name": "ベンチプレス",
                "desc": "60kg*10回*3セット",
                "status": "scheduled",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 27, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 27, hour: 13, minute: 30)),
                "expired_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 3, hour: 23, minute: 59)),
                "created_dt" : Date()
            ],
            [
                "id" : UUID(),
                "name": "ベンチプレス",
                "desc": "60kg*10回*3セット",
                "status": "completed",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 28, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 28, hour: 13, minute: 30)),
                "expired_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 4, hour: 23, minute: 59)),
                "created_dt" : Date()
            ],
            [
                "id" : UUID(),
                "name": "ベンチプレス",
                "desc": "60kg*10回*3セット",
                "status": "abandoned",
                "scheduled_begin_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 29, hour: 12, minute: 30)),
                "scheduled_end_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 29, hour: 13, minute: 30)),
                "expired_dt" : Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 5, hour: 23, minute: 59)),
                "created_dt" : Date()
            ]
        ]
        
        let activitiesData : [[String : Any]] = [
            [
                "id" : UUID(),
                "name": "トレーニングの記録",
                "desc": "ベンチプレスを目標通り10回3セット実行できた。",
                "created_dt" : Date(),
                "updated_dt" : Date()
            ]
        ]
        
        let project = Project(context: context)
        project.id = projectData[0]["id"] as? UUID ?? UUID()
        project.name = projectData[0]["name"] as? String ?? "無題のプロジェクト"
        project.desc = projectData[0]["desc"] as? String ?? "説明文がありません。"
        project.created_dt = projectData[0]["created_dt"] as? Date ?? Date()
        
        for (n, taskSeeder) in tasksData.enumerated() {
            let task = Task(context: context)
            task.id = UUID()
            task.name = taskSeeder["name"] as? String ?? "無題のタスク"
            task.desc = taskSeeder["desc"] as? String ?? "説明文がありません。"
            task.status = taskSeeder["status"] as? String ?? "scheduled"
            task.scheduled_begin_dt = taskSeeder["scheduled_begin_dt"] as? Date
            task.scheduled_end_dt = taskSeeder["scheduled_end_dt"] as? Date
            task.created_dt = taskSeeder["created_dt"] as? Date ?? Date()
            task.updated_dt = taskSeeder["created_dt"] as? Date
            task.expired_dt = taskSeeder["expired_dt"] as? Date
            task.project = project
            project.addToTasks(task)
            
            if n == 0 {
                for activitySeeder in activitiesData{
                    let activity = Activity(context: context)
                    activity.id = UUID()
                    activity.name = activitySeeder["name"] as? String ?? "無題のアクティビティ"
                    activity.desc = activitySeeder["desc"] as? String ?? "説明文がありません。"
                    activity.created_dt = activitySeeder["created_dt"] as? Date ?? Date()
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

