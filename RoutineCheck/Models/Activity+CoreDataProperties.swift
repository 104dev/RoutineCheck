//
//  Activity+CoreDataProperties.swift
//  RoutineCheck
//
//  Created by jushiro watanabe on 2023/08/15.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var created_dt: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var updated_dt: Date?
    @NSManaged public var project: Project?
    @NSManaged public var task: Task?

}

extension Activity : Identifiable {

}
