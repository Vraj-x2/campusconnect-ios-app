//
//  GroupDetailViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit

class GroupDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var groupCourseLabel: UILabel!
    @IBOutlet weak var groupTimeLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var joinGroupButton: UIButton!

    // This will be passed from the previous screen
    var group: StudyGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGroupDetails()
    }

    func updateGroupDetails() {
        guard let group = group else { return }

        groupCourseLabel.text = group.course
        membersCountLabel.text = "Members: \(group.currentMembers)/\(group.maxMembers)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        groupTimeLabel.text = formatter.string(from: group.time ?? Date())

        joinGroupButton.isEnabled = group.currentMembers < group.maxMembers
    }

    @IBAction func joinGroupTapped(_ sender: UIButton) {
        guard let group = group else { return }

        let success = GroupMatchingAlgorithm.joinGroup(group)

        if success {
            showAlert(title: "✅ Joined!", message: "You have joined the group.")
            updateGroupDetails()
        } else {
            showAlert(title: "Group Full", message: "Sorry, this group is already full.")
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
