//
//  ProfileViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Ajay Jesa Odedara
//

import UIKit
import SQLite3

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var academicProgressLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!

    var db: OpaquePointer?
    var currentUserEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        openDatabase()
        fetchLoggedInUser()
        toggleEditing(false)
    }

    // MARK: - Open SQLite database
    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("CampusConnect.db")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ Error opening database")
        }
    }

    // MARK: - Fetch logged in user details
    func fetchLoggedInUser() {
        let defaults = UserDefaults.standard
        guard let emailKey = defaults.string(forKey: "loggedInUserEmail") else {
            print("❌ No user logged in")
            return
        }
        currentUserEmail = emailKey

        let query = "SELECT studentID, fullName, email FROM Users WHERE email = ? LIMIT 1"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (emailKey as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_ROW {
                let studentID = String(cString: sqlite3_column_text(stmt, 0))
                let fullName = String(cString: sqlite3_column_text(stmt, 1))
                let email = String(cString: sqlite3_column_text(stmt, 2))

                updateUI(studentID: studentID, fullName: fullName, email: email)
            } else {
                print("❌ No matching user found")
            }
        } else {
            print("❌ Failed to prepare SELECT statement")
        }

        sqlite3_finalize(stmt)
    }

    // MARK: - Update UI with fetched values
    func updateUI(studentID: String, fullName: String, email: String) {
        nameLabel.text = fullName
        nameTextField.text = fullName
        studentIDLabel.text = studentID
        emailLabel.text = email
        academicProgressLabel.text = "Courses Completed: 8/12"
    }

    // MARK: - Toggle UI for Edit/Save
    func toggleEditing(_ editing: Bool) {
        nameLabel.isHidden = editing
        nameTextField.isHidden = !editing
        nameTextField.isUserInteractionEnabled = editing

        nameTextField.textColor = editing ? .systemBlue : .label
        studentIDLabel.textColor = .label
        emailLabel.textColor = .label

        saveButton.isHidden = !editing
        editProfileButton.isHidden = editing
    }

    // MARK: - Edit Button Action
    @IBAction func editProfileTapped(_ sender: UIButton) {
        toggleEditing(true)
    }

    // MARK: - Save Button Action
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let updatedName = nameTextField.text, !updatedName.isEmpty else { return }
        guard let emailKey = currentUserEmail else { return }

        let updateQuery = "UPDATE Users SET fullName = ? WHERE email = ?"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, updateQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (updatedName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (emailKey as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_DONE {
                updateUI(studentID: studentIDLabel.text ?? "", fullName: updatedName, email: emailKey)
                toggleEditing(false)
                showAlert(title: "Saved", message: "Your profile has been updated.")
            } else {
                print("❌ Failed to update user")
            }
        }

        sqlite3_finalize(stmt)
    }

    // MARK: - Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
    }
    */
}
