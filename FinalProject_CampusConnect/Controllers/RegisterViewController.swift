//
//  RegisterViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Vraj Contractor.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Register Account
    @IBAction func registerAccountTapped(_ sender: UIButton) {
        guard let studentID = studentIDTextField.text, !studentID.isEmpty,
              let fullName = fullNameTextField.text, !fullName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Incomplete", message: "All fields are required.")
            return
        }

        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return
        }

        if AuthenticationManager.register(studentID: studentID, fullName: fullName, email: email, password: password) {
            print("✅ Registration successful")
            showAlert(title: "Success", message: "Account created! Please login.")
        } else {
            showAlert(title: "Error", message: "Registration failed. Email or ID might already exist.")
        }
    }

    // MARK: - Go Back to Login
    @IBAction func backToLoginTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Alert
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
