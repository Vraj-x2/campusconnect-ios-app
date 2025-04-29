//
//  Resource.swift
//  FinalProject_CampusConnect
//
//  Created by Ajay Jesa Odedara
//

import Foundation
import CoreData

@objc(Resource)
public class Resource: NSManagedObject {}

extension Resource {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Resource> {
        return NSFetchRequest<Resource>(entityName: "Resource")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var fileURL: String?
}

