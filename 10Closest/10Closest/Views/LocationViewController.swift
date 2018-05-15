//
//  ViewController.swift
//  10Closest
//
//  Created by Lucas Santos on 09/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, LocationViewProtocol, MKMapViewDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    private let presenter = LocationPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        mapView.delegate = self
        
        searchBar.delegate = self
        
    }

    
    // MARK: - Location Protocol Implementation
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func setLocations(/*_ locations: [LocationModel]*/) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: -23.314974, longitude: -45.975469)
//        mapView.addAnnotation(annotation)
    }
    
    func cleanLocations() {
        
    }
    
    // MARK: - SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, let coordinates =  locationManager.location?.coordinate{
            presenter.requestLocations(text, coordinates: coordinates)
        }
    }
    
    // MARK: - MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        } else {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "teste"){
                return annotationView
            }else{
                let teste = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "teste")
                teste.displayPriority = .required
                return teste
            }
        }
    }
    
    func centerOnUserLocation(){
        if let coordinates = locationManager.location?.coordinate {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinates, 200, 200), animated: true)
        }
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            centerOnUserLocation()
        case .authorizedAlways:
            manager.startUpdatingLocation()
            centerOnUserLocation()
        case .restricted:
            break
        case .denied:
            break
        }
    }
    


}

