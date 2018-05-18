//
//  MapPresenter.swift
//  10Closest
//
//  Created by Lucas Santos on 13/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import CoreLocation

class LocationPresenter{
    
    private weak var locationView: LocationViewProtocol!
    private let locationService: LocationService
    var locManager: CLLocationManager!
    
    var locations = [LocationModel]()
    
    init(service: LocationService) {
        locationService = service
    }
    
    func attachView(_ view: LocationViewProtocol){
        self.locationView = view
    }
    
    func requestLocations(_ keywords: String, coordinates: CLLocationCoordinate2D){
        self.locationView.startLoading()
        let requestModel = LocationRequestModel(keyword: keywords, location: coordinates.toString(), radius: Constants.MAXRADIUS, language: "pt-BR", type: nil)
        locationService.searchLocations(request: requestModel, callBack: { (locations, response) -> Void in
            switch response{
            case 200:
                self.locations = locations
                if(self.locations.count == 0){
                    self.noLocationFound()
                }
                else{
                    self.setLocations()
                }
            case -1:
                self.errorRequestingLocations()
            default:
                break
            }
            
            if Thread.isMainThread{
                self.locationView.finishLoading()
            } else {
                DispatchQueue.main.async {
                    self.locationView.finishLoading()
                }
            }
        })
    }
    
    func noLocationFound(){
        if Thread.isMainThread{
            locationView.noLocationFound()
        } else {
            DispatchQueue.main.async {
                self.locationView.noLocationFound()
            }
        }
    }
    
    func setLocations(){
        let maxRange = locations.count >= 10 ? 10 : locations.count
        if Thread.isMainThread{
            self.locationView.setLocations(Array(self.locations[0..<maxRange]))
        } else {
            DispatchQueue.main.async {
                self.locationView.setLocations(Array(self.locations[0..<maxRange]))
            }
        }
    }
    
    func errorRequestingLocations(){
        if Thread.isMainThread{
            self.locationView.onErrorFindingLocations()
        } else {
            DispatchQueue.main.async {
                self.locationView.onErrorFindingLocations()
            }
        }
    }
}

extension CLLocationCoordinate2D {
    func toString() -> String{
        return "\(self.latitude),\(self.longitude)"
    }
}
