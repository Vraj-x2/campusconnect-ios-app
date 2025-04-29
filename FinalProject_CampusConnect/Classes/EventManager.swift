//
//  EventManager.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel.
//

import Foundation
import UIKit
import CoreData

class EventManager {
    
    static func fetchEvents(for date: Date) -> [Event] {
        var events: [Event] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            events = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch events: \(error)")
        }
        
        return events
    }

    static func searchEvents(keyword: String) -> [Event] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR location CONTAINS[cd] %@", keyword, keyword)

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Search failed")
            return []
        }
    }
}
