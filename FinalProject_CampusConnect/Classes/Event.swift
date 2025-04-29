//
//  Event.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel.
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {}

extension Event {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var location: String?
    @NSManaged public var date: Date?
    @NSManaged public var details: String?
}

