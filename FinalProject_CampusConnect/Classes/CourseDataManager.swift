//
//  CourseDataManager.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import Foundation
import UIKit
import CoreData

class CourseDataManager {
    
    static func addCourse(name: String, grade: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let course = Course(context: context)
        course.id = UUID()
        course.name = name
        course.grade = grade

        do {
            try context.save()
            print("✅ Course saved")
        } catch {
            print("❌ Failed to save course: \(error)")
        }
    }

    static func fetchCourses() -> [Course] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Course> = Course.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch failed: \(error)")
            return []
        }
    }

    static func calculateGPA(from courses: [Course]) -> Double {
        guard !courses.isEmpty else { return 0.0 }
        let total = courses.map { $0.grade }.reduce(0, +)
        return total / Double(courses.count)
    }
}

