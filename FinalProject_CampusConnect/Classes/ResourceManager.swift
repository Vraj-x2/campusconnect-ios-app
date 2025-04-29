//
//  ResourceManager.swift
//  FinalProject_CampusConnect
//
//  Created by Ajay Jesa Odedara
//

import Foundation
import UIKit
import CoreData

class ResourceManager {
    
    static func saveResource(title: String, fileURL: URL) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let resource = Resource(context: context)
        resource.id = UUID()
        resource.title = title
        resource.fileURL = fileURL.absoluteString

        do {
            try context.save()
            print("✅ Resource saved")
        } catch {
            print("❌ Failed to save resource: \(error)")
        }
    }

    static func fetchResources() -> [Resource] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Resource> = Resource.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch failed: \(error)")
            return []
        }
    }
}

