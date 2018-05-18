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

class LocationViewController: UIViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var detailView: DetailView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var detailConstraint: NSLayoutConstraint!
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation?
    var switching = 0
    private let presenter = LocationPresenter(service: LocationService())
    private var locations = [LocationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        mapView.delegate = self
        searchBar.delegate = self
        
        mapView.frame.size.height = 0
        
        presenter.attachView(self)
    }
    
    // MARK: - Button Actions
    @IBAction func touchSettings(_ sender: UIButton) {
    }
    
    @IBAction func touchMyLocation(_ sender: Any) {
        centerOnUserLocation()
    }
    
    func cleanLocations(centeringOnUser: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        hideDetail()
        if(centeringOnUser) {
            centerOnUserLocation()
        }
    }
    
    func hideDetail(){
        UIView.animate(withDuration: 1){
            self.detailConstraint.constant = 0;
            self.view.layoutIfNeeded()
        }
    }
    
    func showDetail(){
        UIView.animate(withDuration: 1){
            self.detailConstraint.constant = 150;
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Location Protocol Implementation
extension LocationViewController : LocationViewProtocol {
    func startLoading() {
        indicatorView.startAnimating()
        settingsButton.isHidden = true
        searchBar.isUserInteractionEnabled = false
    }
    
    func finishLoading() {
        indicatorView.stopAnimating()
        settingsButton.isHidden = false
        searchBar.isUserInteractionEnabled = true
    }
    
    func setLocations(_ locations: [LocationModel]) {
        self.locations = locations
        cleanLocations(centeringOnUser: false)
        var annotations = [MKAnnotation]()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.geometry.location.lat), longitude: CLLocationDegrees(location.geometry.location.lng))
            annotation.title = location.name
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func noLocationFound() {
        showAlert(message: "Nenhum local encontrado", blocking: false)
    }
    
    func onErrorFindingLocations() {
        showAlert(message: "Erro ao buscar locais", blocking: false)
    }
    
    func showAlert(message: String, blocking: Bool){
        let alertController = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        if(!blocking){
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate
extension LocationViewController : UISearchBarDelegate {
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
}


extension LocationViewController : CLLocationManagerDelegate, MKMapViewDelegate {
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
            showAlert(message: "Desabilite a restrição de localização para que este app funcione corretamente", blocking: true)
            break
        case .denied:
            showAlert(message: "Este app necessita autorização do uso de sua localização para seu funcionamento", blocking: true)
            break
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
                return teste
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation is MKUserLocation /*|| selectedAnnotation?.title == view.annotation?.title*/){
            selectedAnnotation = nil
            return
        }
        selectedAnnotation = view.annotation
        switching += 1
        
        let location = locations.first(where: {$0.name == selectedAnnotation?.title})
        detailView.locationModel = location
        
        if let coordinate = view.annotation?.coordinate{
            UIView.animate(withDuration: 1){
                self.centerOnLocation(coordinate)
                self.detailConstraint.constant = 150;
                self.view.layoutIfNeeded()
            }
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        switching -= 1
        if (switching == 2){
            return
        }
        hideDetail()
    }
    
    func centerOnUserLocation(){
        if let coordinates = locationManager.location?.coordinate {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinates, 200, 200), animated: true)
        }
    }
    
    func centerOnLocation(_ location: CLLocationCoordinate2D){
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 200, 200), animated: true)
    }
}

