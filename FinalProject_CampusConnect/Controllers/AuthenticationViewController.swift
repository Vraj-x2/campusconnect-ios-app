//
//  AuthenticationViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Vraj Contractor.
//


import UIKit

class AuthenticationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Login Action
    @IBAction func loginTapped(_ sender: UIButton) {
        // Validate input
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Info", message: "Please enter both email and password.")
            return
        }

        // Try logging in
        if AuthenticationManager.login(email: email, password: password) {
            print("✅ Login successful for \(email)")

            // Save the logged-in email to UserDefaults
            UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
            UserDefaults.standard.synchronize()

            // Proceed to dashboard (use segue or storyboard ID)
            performSegue(withIdentifier: "goToDashboard", sender: self)
        } else {
            showAlert(title: "Login Failed", message: "Incorrect email or password.")
        }
    }

    // MARK: - Go to Register Screen
    @IBAction func goToRegisterTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }

    // MARK: - Helper
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
