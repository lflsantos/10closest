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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var settingsButton: UIButton!
    
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
        
        presenter.attachView(self)
        
    }
    
    // MARK: - Button Actions
    @IBAction func touchSettings(_ sender: UIButton) {
    }
    
    @IBAction func touchMyLocation(_ sender: Any) {
        centerOnUserLocation()
    }
    

    
    // MARK: - Location Protocol Implementation
    func startLoading() {
        indicatorView.startAnimating()
        settingsButton.isHidden = true
    }
    
    func finishLoading() {
        indicatorView.stopAnimating()
        settingsButton.isHidden = false
    }
    
    func setLocations(_ locations: [LocationModel]) {
        cleanLocations(centeringOnUser: false)
        var annotations = [MKAnnotation]()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.geometry.location.lat), longitude: CLLocationDegrees(location.geometry.location.lng))
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func cleanLocations(centeringOnUser: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        if(centeringOnUser) {
            centerOnUserLocation()
        }
    }
    
    // MARK: - SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "", let coordinates =  locationManager.location?.coordinate{
            presenter.requestLocations(text, coordinates: coordinates)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            cleanLocations(centeringOnUser: true)
        }
    }
    
    // MARK: - MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        } else {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationIdentifier"){
                return annotationView
            }else{
                let teste = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
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

