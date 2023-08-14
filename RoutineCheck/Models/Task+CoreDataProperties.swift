//
//  Task+CoreDataProperties.swift
//  RoutineCheck
//
//  Created by jushiro watanabe on 2023/08/15.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var begin_dt: Date?
    @NSManaged public var created_dt: Date?
    @NSManaged public var desc: String?
    @NSManaged public var end_dt: Date?
    @NSManaged public var expired_dt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var scheduled_begin_dt: Date?
    @NSManaged public var scheduled_end_dt: Date?
    @NSManaged public var status: String?
    @NSManaged public var updated_dt: Date?
    @NSManaged public var activities: NSSet?
    @NSManaged public var project: Project?

}

// MARK: Generated accessors for activities
extension Task {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

extension Task : Identifiable {

}
