//
//  Course.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta
//

import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject {}

extension Course {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var grade: Double
}

