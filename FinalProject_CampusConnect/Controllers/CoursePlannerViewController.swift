//
//  CoursePlannerViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//


import UIKit
import CoreData

class CoursePlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var courseTableView: UITableView!

    var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        courseTableView.delegate = self
        courseTableView.dataSource = self
        loadCourses()
    }

    // MARK: - Load from Core Data
    func loadCourses() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Course> = Course.fetchRequest()

        do {
            courses = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch courses: \(error)")
        }

        updateGPA()
        courseTableView.reloadData()
    }

    // MARK: - Convert Percentage to GPA Points
    func gpaPoints(for grade: Double) -> Double {
        switch grade {
        case 90...100: return 4.0
        case 85..<90: return 3.8
        case 80..<85: return 3.6
        case 75..<80: return 3.3
        case 70..<75: return 3.0
        case 65..<70: return 2.5
        case 60..<65: return 2.0
        case 55..<60: return 1.5
        case 50..<55: return 1.0
        default: return 0.0
        }
    }

    // MARK: - GPA Calculation
    func updateGPA() {
        guard !courses.isEmpty else {
            gpaLabel.text = "GPA: 0.00"
            return
        }

        let totalGPA = courses.map { gpaPoints(for: $0.grade) }.reduce(0, +)
        let averageGPA = totalGPA / Double(courses.count)
        gpaLabel.text = String(format: "GPA: %.2f", averageGPA)
    }

    // MARK: - Add Course Button
    @IBAction func addCourseTapped(_ sender: UIButton) {
        guard let name = courseNameTextField.text, !name.isEmpty,
              let gradeText = gradeTextField.text,
              let grade = Double(gradeText), grade >= 0, grade <= 100 else {
            showAlert(title: "Invalid Input", message: "Please enter a valid course name and grade (0-100).")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let course = Course(context: context)
        course.id = UUID()
        course.name = name
        course.grade = grade

        do {
            try context.save()
            courses.append(course)
            courseTableView.reloadData()
            updateGPA()
            courseNameTextField.text = ""
            gradeTextField.text = ""
        } catch {
            print("❌ Failed to save course: \(error)")
        }
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = courses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        cell.textLabel?.text = course.name
        cell.detailTextLabel?.text = "Grade: \(course.grade)%"
        return cell
    }

    // MARK: - Show Alert on Tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        let gpa = gpaPoints(for: course.grade)
        let message = "Name: \(course.name ?? "N/A")\nGrade: \(course.grade)%\nGPA Points: \(gpa)"
        showAlert(title: "Course Info", message: message)
    }

    // MARK: - Delete Support
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(courses[indexPath.row])

            do {
                try context.save()
                courses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateGPA()
            } catch {
                print("❌ Failed to delete course")
            }
        }
    }

    // MARK: - Alert Utility
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Unwind
    @IBAction func unwindToCoursePlanner(_ segue: UIStoryboardSegue) {}
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


