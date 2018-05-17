//
//  MapPresenter.swift
//  10Closest
//
//  Created by Lucas Santos on 13/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import CoreLocation

class LocationPresenter : NSObject, CLLocationManagerDelegate{
    
    private weak var locationView: LocationViewProtocol!
    private let locationService: LocationSearchService
    var locManager: CLLocationManager!
    
    var locations = [LocationModel]()
    
    override init() {
        locationService = LocationSearchService()
        
    }
    
    func attachView(_ view: LocationViewProtocol){
        self.locationView = view
    }
    
    func requestLocations(_ keywords: String, coordinates: CLLocationCoordinate2D){
        self.locationView.startLoading()
        let requestModel = LocationRequestModel(keyword: keywords, location: coordinates.toString(), radius: Constants.MAXRADIUS, language: "pt-BR", type: nil)
        locationService.searchLocations(request: requestModel, callBack: { (locations) -> Void in
            self.locations = locations
            DispatchQueue.main.async {
                let maxRange = locations.count >= 10 ? 10 : locations.count
                self.locationView.setLocations(Array(locations[0..<maxRange]))
                self.locationView.finishLoading()
            }
        })
    }
}

extension CLLocationCoordinate2D {
    func toString() -> String{
        return "\(self.latitude),\(self.longitude)"
    }
}
