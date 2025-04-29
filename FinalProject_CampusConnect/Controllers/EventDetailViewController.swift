//
//  EventDetailViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel 
//

import UIKit
import MapKit
import EventKit
import EventKitUI

class EventDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventMapView: MKMapView!
    
    // Passed from previous VC
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetails()
    }

    func configureDetails() {
        guard let event = event else { return }

        eventTitleLabel.text = event.title
        eventDateLabel.text = formatDate(event.date ?? Date())
        eventLocationLabel.text = event.location
        eventDescriptionTextView.text = event.details

        // Geocode location & show on map
        if let location = event.location {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location) { placemarks, error in
                if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = event.title
                    self.eventMapView.addAnnotation(annotation)
                    self.centerMap(coordinate: coordinate)
                }
            }
        }
    }

    func centerMap(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        eventMapView.setRegion(region, animated: true)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // MARK: - RSVP Button
    @IBAction func rsvpButtonTapped(_ sender: UIButton) {
        showAlert(title: "RSVP Confirmed", message: "You have successfully RSVP’d to this event!")
    }

    // MARK: - Add to Calendar
    @IBAction func addToCalendarTapped(_ sender: UIButton) {
        guard let event = event else { return }

        let ekEvent = EKEvent(eventStore: EKEventStore())
        ekEvent.title = event.title ?? "Campus Event"
        ekEvent.startDate = event.date
        ekEvent.endDate = event.date?.addingTimeInterval(2 * 60 * 60)
        ekEvent.calendar = EKEventStore().defaultCalendarForNewEvents

        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                do {
                    try eventStore.save(ekEvent, span: .thisEvent)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Added to Calendar", message: "Event added to your calendar.")
                    }
                } catch {
                    print("❌ Error saving to calendar")
                }
            }
        }
    }

    // MARK: - Share Button
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let event = event else { return }
        let shareText = "Check out this event: \(event.title ?? "") at \(event.location ?? "") on \(formatDate(event.date ?? Date()))"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
