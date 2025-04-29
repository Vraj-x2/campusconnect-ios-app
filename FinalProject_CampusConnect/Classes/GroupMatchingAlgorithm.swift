//
//  GroupMatchingAlgorithm.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import Foundation
import UIKit
import CoreData

class GroupMatchingAlgorithm {
    
    static func fetchGroups(filter keyword: String? = nil) -> [StudyGroup] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<StudyGroup> = StudyGroup.fetchRequest()
        
        if let keyword = keyword, !keyword.isEmpty {
            request.predicate = NSPredicate(format: "course CONTAINS[cd] %@", keyword)
        }

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Failed to fetch study groups: \(error)")
            return []
        }
    }

    static func joinGroup(_ group: StudyGroup) -> Bool {
        guard group.currentMembers < group.maxMembers else { return false }

        group.currentMembers += 1

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
            return true
        } catch {
            print("❌ Could not update group.")
            return false
        }
    }
}

