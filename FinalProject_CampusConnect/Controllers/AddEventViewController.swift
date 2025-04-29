//
//  AddEventViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel 
//
import UIKit
import CoreData

class AddEventViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Optional styling
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
    }

    // MARK: - Save Event
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let details = descriptionTextView.text, !details.isEmpty else {
            showAlert(title: "Missing Fields", message: "Please fill all fields.")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newEvent = Event(context: context)
        newEvent.id = UUID()
        newEvent.title = title
        newEvent.location = location
        newEvent.date = datePicker.date
        newEvent.details = details

        do {
            try context.save()
            print("✅ Event saved.")
            dismiss(animated: true) // or use unwind segue
        } catch {
            print("❌ Failed to save event: \(error)")
            showAlert(title: "Error", message: "Could not save the event.")
        }
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
