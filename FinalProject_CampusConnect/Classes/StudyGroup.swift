//
//  StudyGroup.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta
//

import Foundation
import CoreData

@objc(StudyGroup)
public class StudyGroup: NSManagedObject {}

extension StudyGroup {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyGroup> {
        return NSFetchRequest<StudyGroup>(entityName: "StudyGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var course: String?
    @NSManaged public var time: Date?
    @NSManaged public var maxMembers: Int16
    @NSManaged public var currentMembers: Int16
}
