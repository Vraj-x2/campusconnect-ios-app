//
//  EventCalendarViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel 
//

import UIKit

class EventCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var eventsTitleLabel: UILabel!
    @IBOutlet weak var calendarPicker: UIDatePicker!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var eventSearchBar: UISearchBar!
    
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventSearchBar.delegate = self
        
        // Load today's events initially
        events = EventManager.fetchEvents(for: calendarPicker.date)
        eventTableView.reloadData()
    }

    // MARK: - Load events on date change
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        events = EventManager.fetchEvents(for: sender.date)
        eventTableView.reloadData()
    }

    // MARK: - Add Event Button
    @IBAction func addEventTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }

    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            events = EventManager.fetchEvents(for: calendarPicker.date)
        } else {
            events = EventManager.searchEvents(keyword: searchText)
        }
        eventTableView.reloadData()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let event = events[indexPath.row]
        cell.textLabel?.text = "\(event.title ?? "No Title") @ \(event.location ?? "")"
        return cell
    }

    // Navigate to Event Detail screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "goToEventDetail", sender: selectedEvent)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetail",
           let detailVC = segue.destination as? EventDetailViewController,
           let selectedEvent = sender as? Event {
            detailVC.event = selectedEvent
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = eventTableView.indexPathForSelectedRow {
            eventTableView.deselectRow(at: indexPath, animated: true)
        }
    }

  

    @IBAction func unwindToEventCalendar(_ segue: UIStoryboardSegue) {
        print("⬅️ Back to Events")
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
