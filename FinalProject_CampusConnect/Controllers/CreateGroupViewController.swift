//
//  CreateGroupViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit

class CreateGroupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var membersStepper: UIStepper!
    @IBOutlet weak var membersLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        membersStepper.minimumValue = 2
        membersStepper.maximumValue = 10
        membersStepper.value = 5
        updateMemberLabel()
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateMemberLabel()
    }

    func updateMemberLabel() {
        membersLabel.text = "Max Members: \(Int(membersStepper.value))"
    }

    @IBAction func createGroupTapped(_ sender: UIButton) {
        guard let course = courseTextField.text, !course.isEmpty else {
            showAlert(title: "Missing Course", message: "Please enter a course name.")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGroup = StudyGroup(context: context)
        newGroup.id = UUID()
        newGroup.course = course
        newGroup.time = timePicker.date
        newGroup.maxMembers = Int16(membersStepper.value)
        newGroup.currentMembers = 1 // creator auto joins

        do {
            try context.save()
            print("✅ Study group created.")
            self.dismiss(animated: true) // or perform unwind segue
        } catch {
            print("❌ Failed to save group: \(error)")
            showAlert(title: "Error", message: "Could not create group.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
