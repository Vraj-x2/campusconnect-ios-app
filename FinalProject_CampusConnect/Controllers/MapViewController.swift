//
//  MapViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Anshul Patel 
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var campusMapView: MKMapView!
    @IBOutlet weak var locationSearchBar: UISearchBar!

    // MARK: - Location and Routing
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var destinationCoordinate: CLLocationCoordinate2D?

    // MARK: - Predefined Campus Locations
    let predefinedLocations: [String: CLLocationCoordinate2D] = [
        "Sheridan College – Davis Campus": CLLocationCoordinate2D(latitude: 43.655787, longitude: -79.739534),
        "A-Wing": CLLocationCoordinate2D(latitude: 43.655800, longitude: -79.739800),
        "B-Wing": CLLocationCoordinate2D(latitude: 43.655879937710466, longitude: -79.73926136198156),
        "C-Wing": CLLocationCoordinate2D(latitude: 43.65697194810029, longitude: -79.73726477004183),
        "Library / J-Wing": CLLocationCoordinate2D(latitude: 43.65746499591063, longitude: -79.74116474394417),
        "Cafeteria / Food Court": CLLocationCoordinate2D(latitude: 43.65639156750804, longitude: -79.73841753969067),
        "Campus Residence": CLLocationCoordinate2D(latitude: 43.657315266394235, longitude: -79.73651853573442),
        "Tim Hortons (C-Wing)": CLLocationCoordinate2D(latitude: 43.656795202382696, longitude: -79.7377630807001),
        "H-Wing": CLLocationCoordinate2D(latitude: 43.65680997108162, longitude: -79.74064767624104),
        "M-Wing": CLLocationCoordinate2D(latitude: 43.65544695967067, longitude: -79.74046884997273),
        "The Den": CLLocationCoordinate2D(latitude: 43.65629842061319, longitude: -79.73970499999999),
        "Lake Side": CLLocationCoordinate2D(latitude: 43.657113716413754, longitude: -79.73809624201672),
        "College Gym": CLLocationCoordinate2D(latitude: 43.65662266825297, longitude: -79.73745926588488)
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        campusMapView.delegate = self
        locationSearchBar.delegate = self
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        campusMapView.showsUserLocation = true

        // Add building pins
        for (title, coord) in predefinedLocations {
            addFixedPin(title: title, coordinate: coord)
        }

        // Initial center
        if let center = predefinedLocations["Sheridan College – Davis Campus"] {
            centerMap(on: center)
        }
    }

    // MARK: - Add Pins & Centering
    func addFixedPin(title: String, coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.coordinate = coordinate
        campusMapView.addAnnotation(pin)
    }

    func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        campusMapView.setRegion(region, animated: true)
    }

    // MARK: - Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased(), !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()

        // 1. Match from known locations
        if let match = predefinedLocations.first(where: { $0.key.lowercased().contains(searchText) }) {
            destinationCoordinate = match.value
            let pin = MKPointAnnotation()
            pin.title = match.key
            pin.coordinate = match.value
            campusMapView.addAnnotation(pin)
            centerMap(on: match.value)
            return
        }

        // 2. External geocoding
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let coord = location.coordinate
                self.destinationCoordinate = coord

                let pin = MKPointAnnotation()
                pin.title = searchText
                pin.coordinate = coord
                self.campusMapView.addAnnotation(pin)
                self.centerMap(on: coord)
            } else {
                print("❌ Could not geocode location.")
            }
        }
    }

    // MARK: - Navigate Button
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        guard let destination = destinationCoordinate else {
            showAlert(title: "No Destination", message: "Please search for a location before navigating.")
            return
        }

        guard let origin = userLocation else {
            showAlert(title: "Location Error", message: "Current location not available.")
            return
        }

        campusMapView.removeOverlays(campusMapView.overlays)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("❌ Directions error: \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else {
                print("❌ No route found.")
                return
            }

            self.campusMapView.addOverlay(route.polyline)
            self.campusMapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                                 edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 60, right: 40),
                                                 animated: true)

            let distance = route.distance / 1000.0
            let eta = route.expectedTravelTime / 60.0
            let message = String(format: "Distance: %.2f km\nETA: %.1f mins", distance, eta)
            self.showAlert(title: "Route Info", message: message)
        }
    }

    // MARK: - Route Overlay Renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    // MARK: - Custom Pin Color
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        let identifier = "RedPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .systemRed
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    // MARK: - User Location Handling
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            userLocation = latest.coordinate
            print("📍 Live location set: \(userLocation!)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location failed: \(error.localizedDescription)")
        
        // Set default to Sheridan College
        userLocation = CLLocationCoordinate2D(latitude: 43.655787, longitude: -79.739534)
        print("⚠️ Using default location: Sheridan College")
        centerMap(on: userLocation!)
    }

    // MARK: - Helper: Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
